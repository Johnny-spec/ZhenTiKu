import { Question, QuestionType } from '../data/QuestionTypes';

interface QuestionOption {
  key?: string;
  label?: string;
  text?: string;
  content?: string;
}

interface QuestionView {
  id: string;
  type: QuestionType | string;
  stem?: string;
  content?: string;
  title?: string;
  options?: Array<string | QuestionOption>;
}

@Component
export struct QuestionCard {
  @Prop q: Question;
  @Prop index: number = 0;
  @Prop isFav: boolean = false;
  onToggleFav: () => void = () => {};
  onShowAnalysis: () => void = () => {};

  private view(): QuestionView {
    return this.q as QuestionView;
  }

  private typeText(): string {
    const value = String(this.view().type);
    const lower = value.toLowerCase();
    if (lower.indexOf('choice') >= 0 || value.indexOf('单选') >= 0) {
      return '选择';
    }
    if (lower.indexOf('fill') >= 0 || value.indexOf('填空') >= 0) {
      return '填空';
    }
    if (lower.indexOf('solve') >= 0 || value.indexOf('解答') >= 0) {
      return '解答';
    }
    return value;
  }

  private stemText(): string {
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

  build() {
    Column() {
      Row() {
        Text(`第${this.index + 1}题`)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')
          .layoutWeight(1)

        Text(this.typeText())
          .fontSize(12)
          .fontColor('#FFFFFF')
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .backgroundColor('#5B7CFF')
          .borderRadius(12)
      }
      .width('100%')

      Text(this.stemText())
        .fontSize(16)
        .fontColor('#111827')
        .lineHeight(24)
        .width('100%')
        .margin({ top: 14 })

      if (this.view().options && this.view().options!.length > 0) {
        Column({ space: 10 }) {
          ForEach(this.view().options!, (option: string | QuestionOption, optIndex: number) => {
            Text(this.optionText(option, optIndex))
              .fontSize(15)
              .fontColor('#374151')
              .width('100%')
              .padding(12)
              .backgroundColor('#F9FAFB')
              .borderRadius(12)
          }, (option: string | QuestionOption, optIndex: number) => `${optIndex}`)
        }
        .width('100%')
        .margin({ top: 12 })
      }

      Row() {
        Button('查看解析')
          .fontSize(14)
          .fontColor('#5B7CFF')
          .backgroundColor('#EEF2FF')
          .borderRadius(16)
          .height(34)
          .onClick(() => {
            this.onShowAnalysis();
          })

        Blank()
          .layoutWeight(1)

        Text(this.isFav ? '★' : '☆')
          .fontSize(28)
          .fontColor(this.isFav ? '#F59E0B' : '#CBD5E1')
          .onClick(() => {
            this.onToggleFav();
          })
      }
      .width('100%')
      .margin({ top: 16 })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(Color.White)
    .borderRadius(18)
    .shadow({ radius: 10, color: '#12000000', offsetY: 4 })
  }
}
