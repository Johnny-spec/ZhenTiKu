import router from '@ohos.router';
import { GradientHeader } from '../components/GradientHeader';
import { Paper, Question } from '../data/QuestionTypes';
import { getPaper } from '../data/QuestionBank';

interface RouteParams {
  paperId?: string;
  qid?: string;
}

interface PaperView {
  id: string;
  title: string;
  questions: Question[];
}

interface QuestionOption {
  key?: string;
  label?: string;
  text?: string;
  content?: string;
}

interface QuestionView {
  id: string;
  stem?: string;
  content?: string;
  title?: string;
  options?: Array<string | QuestionOption>;
  answer?: string;
  analysis?: string;
  knowledge?: string | string[];
}

@Entry
@Component
struct QuestionDetailPage {
  @State paperId: string = '';
  @State qid: string = '';
  @State question: Question | undefined = undefined;
  @State showAnswer: boolean = false;

  aboutToAppear(): void {
    const params = router.getParams() as RouteParams;
    this.paperId = params.paperId || '';
    this.qid = params.qid || '';
    const paper = getPaper(this.paperId) as Paper;
    if (paper) {
      this.question = (paper as PaperView).questions.find((item: Question) => {
        return (item as QuestionView).id === this.qid;
      });
    }
  }

  private view(): QuestionView {
    return this.question as QuestionView;
  }

  private stemText(): string {
    if (!this.question) {
      return '';
    }
    const item = this.view();
    return item.stem || item.content || item.title || '';
  }

  private optionText(option: string | QuestionOption, index: number): string {
    if (typeof option === 'string') {
      return `${String.fromCharCode(65 + index)}. ${option}`;
    }
    const key = option.key || option.label || String.fromCharCode(65 + index);
    return `${key}. ${option.text || option.content || ''}`;
  }

  private knowledgeTags(): string[] {
    const value = this.view().knowledge;
    if (value === undefined) {
      return [];
    }
    if (typeof value === 'string') {
      return [value];
    }
    return value;
  }

  @Builder
  private AnswerBlock() {
    Column() {
      Text(`答案：${this.view().answer || '暂无答案'}`)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111827')
        .width('100%')
      Text(this.view().analysis || '暂无解析')
        .fontSize(16)
        .fontColor('#374151')
        .lineHeight(25)
        .width('100%')
        .margin({ top: 10 })
      if (this.knowledgeTags().length > 0) {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.knowledgeTags(), (tag: string) => {
            Text(tag)
              .fontSize(13)
              .fontColor('#5B7CFF')
              .padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .backgroundColor('#EEF2FF')
              .borderRadius(12)
              .margin({ right: 8, top: 8 })
          }, (tag: string) => tag)
        }
        .width('100%')
        .margin({ top: 8 })
      }
    }
    .width('100%')
    .padding(18)
    .backgroundColor('#FFF7ED')
    .borderRadius(16)
    .margin({ top: 16 })
  }

  build() {
    Column() {
      GradientHeader({ title: '题目详情', showBack: true })

      Scroll() {
        Column() {
          if (this.question) {
            Text(this.stemText())
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor('#111827')
              .lineHeight(30)
              .width('100%')
              .padding(20)
              .backgroundColor(Color.White)
              .borderRadius(18)

            if (this.view().options && this.view().options!.length > 0) {
              Column({ space: 12 }) {
                ForEach(this.view().options!, (option: string | QuestionOption, index: number) => {
                  Text(this.optionText(option, index))
                    .fontSize(16)
                    .fontColor('#374151')
                    .width('100%')
                    .padding(16)
                    .backgroundColor(Color.White)
                    .borderRadius(14)
                }, (option: string | QuestionOption, index: number) => `${index}`)
              }
              .width('100%')
              .margin({ top: 16 })
            }

            Button(this.showAnswer ? '隐藏答案' : '显示答案')
              .width('100%')
              .height(46)
              .fontSize(16)
              .backgroundColor('#5B7CFF')
              .borderRadius(23)
              .margin({ top: 18 })
              .onClick(() => {
                this.showAnswer = !this.showAnswer;
              })

            if (this.showAnswer) {
              this.AnswerBlock()
            }
          } else {
            Text('未找到题目')
              .fontSize(18)
              .fontColor('#6B7280')
              .margin({ top: 160 })
          }
        }
        .width('100%')
        .padding(18)
      }
      .layoutWeight(1)
      .backgroundColor('#F6F7FB')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F7FB')
  }
}
