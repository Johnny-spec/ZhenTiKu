import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import { GradientHeader } from '../components/GradientHeader';
import { QuestionCard } from '../components/QuestionCard';
import { Paper, Question } from '../data/QuestionTypes';
import { getPaper } from '../data/QuestionBank';
import { favoriteStore } from '../data/FavoriteStore';

interface RouteParams {
  paperId?: string;
}

interface PaperView {
  id: string;
  title: string;
  questions: Question[];
}

interface QuestionView {
  id: string;
  answer?: string;
  analysis?: string;
}

@Entry
@Component
struct PaperListPage {
  @State paperId: string = '';
  @State paper: Paper | undefined = undefined;
  @State expandedSet: Set<string> = new Set<string>();
  @State favSet: Set<string> = new Set<string>();

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as RouteParams;
    this.paperId = params.paperId || '';
    this.paper = getPaper(this.paperId);
    await favoriteStore.init(getContext(this) as common.UIAbilityContext);
    const ids = await favoriteStore.list() as string[];
    this.favSet = new Set<string>(ids);
  }

  private title(): string {
    if (this.paper) {
      return (this.paper as PaperView).title;
    }
    return '试卷详情';
  }

  private questions(): Question[] {
    if (this.paper) {
      return (this.paper as PaperView).questions;
    }
    return [];
  }

  private questionId(q: Question): string {
    return (q as QuestionView).id;
  }

  private isExpanded(q: Question): boolean {
    return this.expandedSet.has(this.questionId(q));
  }

  private isFavorite(q: Question): boolean {
    return this.favSet.has(this.questionId(q));
  }

  private toggleExpanded(q: Question): void {
    const next = new Set<string>(this.expandedSet);
    const id = this.questionId(q);
    if (next.has(id)) {
      next.delete(id);
    } else {
      next.add(id);
    }
    this.expandedSet = next;
  }

  private async toggleFavorite(q: Question): Promise<void> {
    const id = this.questionId(q);
    if (this.favSet.has(id)) {
      await favoriteStore.remove(id);
      const next = new Set<string>(this.favSet);
      next.delete(id);
      this.favSet = next;
    } else {
      await favoriteStore.add(id);
      const next = new Set<string>(this.favSet);
      next.add(id);
      this.favSet = next;
    }
  }

  @Builder
  private AnalysisBlock(q: Question) {
    Column() {
      Text(`答案：${(q as QuestionView).answer || '暂无答案'}`)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111827')
        .width('100%')
      Text((q as QuestionView).analysis || '暂无解析')
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
      GradientHeader({ title: this.title(), showBack: true })

      if (this.questions().length === 0) {
        Column() {
          Text('暂无题目')
            .fontSize(18)
            .fontColor('#6B7280')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 14 }) {
          ForEach(this.questions(), (q: Question, index: number) => {
            ListItem() {
              Column() {
                QuestionCard({
                  q: q,
                  index: index,
                  isFav: this.isFavorite(q),
                  onToggleFav: () => {
                    this.toggleFavorite(q);
                  },
                  onShowAnalysis: () => {
                    this.toggleExpanded(q);
                  }
                })
                if (this.isExpanded(q)) {
                  this.AnalysisBlock(q)
                }
              }
            }
          }, (q: Question) => this.questionId(q))
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
