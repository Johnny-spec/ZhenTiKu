import { GradientHeader } from '../components/GradientHeader';
import { QuestionCard } from '../components/QuestionCard';
import { Question } from '../data/QuestionTypes';
import { searchQuestions } from '../data/QuestionBank';

interface QuestionView {
  id: string;
  answer?: string;
  analysis?: string;
}

@Entry
@Component
struct SearchPage {
  @State keyword: string = '';
  @State results: Question[] = [];
  @State expandedSet: Set<string> = new Set<string>();

  private doSearch(value: string): void {
    this.keyword = value;
    const text = value.trim();
    if (text.length === 0) {
      this.results = [];
      return;
    }
    this.results = searchQuestions(text);
  }

  private questionId(q: Question): string {
    return (q as QuestionView).id;
  }

  private isExpanded(q: Question): boolean {
    return this.expandedSet.has(this.questionId(q));
  }

  private toggleExpanded(q: Question): void {
    const id = this.questionId(q);
    const next = new Set<string>(this.expandedSet);
    if (next.has(id)) {
      next.delete(id);
    } else {
      next.add(id);
    }
    this.expandedSet = next;
  }

  @Builder
  private EmptyState() {
    Column() {
      Text(this.keyword.length === 0 ? '输入关键词开始搜索' : '未找到相关题目')
        .fontSize(17)
        .fontColor('#6B7280')
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
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
      GradientHeader({ title: '搜索题目', showBack: true })

      Column() {
        TextInput({ placeholder: '请输入题干或知识点', text: this.keyword })
          .height(48)
          .fontSize(16)
          .backgroundColor(Color.White)
          .borderRadius(24)
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.doSearch(value);
          })

        if (this.results.length === 0) {
          this.EmptyState()
        } else {
          List({ space: 14 }) {
            ForEach(this.results, (q: Question, index: number) => {
              ListItem() {
                Column() {
                  QuestionCard({
                    q: q,
                    index: index,
                    isFav: false,
                    onToggleFav: () => {},
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
          .margin({ top: 16 })
        }
      }
      .width('100%')
      .layoutWeight(1)
      .padding(18)
      .backgroundColor('#F6F7FB')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F7FB')
  }
}
