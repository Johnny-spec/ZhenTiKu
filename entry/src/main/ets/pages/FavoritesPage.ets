import common from '@ohos.app.ability.common';
import { GradientHeader } from '../components/GradientHeader';
import { QuestionCard } from '../components/QuestionCard';
import { GradeInfo, Paper, Question } from '../data/QuestionTypes';
import { GRADES } from '../data/Grades';
import { getAllSubjectsForGrade, getPapers } from '../data/QuestionBank';
import { favoriteStore } from '../data/FavoriteStore';

interface GradeView {
  id: string;
}

interface PaperView {
  id: string;
  questions: Question[];
}

interface QuestionView {
  id: string;
  answer?: string;
  analysis?: string;
}

interface FavQuestionItem {
  paperId: string;
  question: Question;
}

@Entry
@Component
struct FavoritesPage {
  @State favIds: string[] = [];
  @State items: FavQuestionItem[] = [];
  @State expandedSet: Set<string> = new Set<string>();

  async aboutToAppear(): Promise<void> {
    await favoriteStore.init(getContext(this) as common.UIAbilityContext);
    this.favIds = await favoriteStore.list() as string[];
    this.collectQuestions();
  }

  private collectQuestions(): void {
    const result: FavQuestionItem[] = [];
    GRADES.forEach((grade: GradeInfo) => {
      const subjects = getAllSubjectsForGrade((grade as GradeView).id);
      subjects.forEach((subjectId: string) => {
        const papers = getPapers((grade as GradeView).id, subjectId);
        papers.forEach((paper: Paper) => {
          (paper as PaperView).questions.forEach((question: Question) => {
            const id = (question as QuestionView).id;
            if (this.favIds.indexOf(id) >= 0) {
              result.push({ paperId: (paper as PaperView).id, question: question });
            }
          });
        });
      });
    });
    this.items = result;
  }

  private questionId(item: FavQuestionItem): string {
    return (item.question as QuestionView).id;
  }

  private isExpanded(item: FavQuestionItem): boolean {
    return this.expandedSet.has(this.questionId(item));
  }

  private toggleExpanded(item: FavQuestionItem): void {
    const id = this.questionId(item);
    const next = new Set<string>(this.expandedSet);
    if (next.has(id)) {
      next.delete(id);
    } else {
      next.add(id);
    }
    this.expandedSet = next;
  }

  private async removeFavorite(item: FavQuestionItem): Promise<void> {
    const id = this.questionId(item);
    await favoriteStore.remove(id);
    this.favIds = this.favIds.filter((value: string) => value !== id);
    this.items = this.items.filter((value: FavQuestionItem) => this.questionId(value) !== id);
  }

  @Builder
  private AnalysisBlock(item: FavQuestionItem) {
    Column() {
      Text(`答案：${(item.question as QuestionView).answer || '暂无答案'}`)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111827')
        .width('100%')
      Text((item.question as QuestionView).analysis || '暂无解析')
        .fontSize(15)
        .fontColor('#4B5563')
        .lineHeight(23)
        .width('100%')
        .margin({ top: 8 })
    }
    .width('100%')
    .padding(14)
    .backgroundColor('#FFF7ED')
    .borderRadius(14)
    .margin({ top: 10 })
  }

  build() {
    Column() {
      GradientHeader({ title: '我的收藏', showBack: true })

      if (this.items.length === 0) {
        Column() {
          Text('📚')
            .fontSize(72)
          Text('暂无收藏')
            .fontSize(18)
            .fontColor('#6B7280')
            .margin({ top: 14 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#F6F7FB')
      } else {
        List({ space: 14 }) {
          ForEach(this.items, (item: FavQuestionItem, index: number) => {
            ListItem() {
              Column() {
                QuestionCard({
                  q: item.question,
                  index: index,
                  isFav: true,
                  onToggleFav: () => {
                    this.removeFavorite(item);
                  },
                  onShowAnalysis: () => {
                    this.toggleExpanded(item);
                  }
                })
                if (this.isExpanded(item)) {
                  this.AnalysisBlock(item)
                }
              }
            }
          }, (item: FavQuestionItem) => this.questionId(item))
        }
        .width('100%')
        .layoutWeight(1)
        .padding(18)
        .backgroundColor('#F6F7FB')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F7FB')
  }
}
