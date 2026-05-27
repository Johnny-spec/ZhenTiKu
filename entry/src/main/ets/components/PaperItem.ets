import { ExamType, Paper, Question } from '../data/QuestionTypes';

interface PaperView {
  id: string;
  title: string;
  year: number;
  examType: ExamType | string;
  questions: Question[];
}

@Component
export struct PaperItem {
  @Prop paper: Paper;
  onTap: () => void = () => {};

  private item(): PaperView {
    return this.paper as PaperView;
  }

  private badgeText(): string {
    const exam = String(this.item().examType).toLowerCase();
    if (exam.indexOf('mid') >= 0 || exam.indexOf('期中') >= 0) {
      return '期中';
    }
    return '期末';
  }

  build() {
    Column() {
      Row() {
        Text(this.item().title)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')
          .layoutWeight(1)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.badgeText())
          .fontSize(12)
          .fontColor('#5B7CFF')
          .fontWeight(FontWeight.Medium)
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .backgroundColor('#EEF2FF')
          .borderRadius(12)
      }
      .width('100%')

      Row() {
        Text(`${this.item().year}年`)
          .fontSize(13)
          .fontColor('#6B7280')

        Blank()
          .layoutWeight(1)

        Text(`${this.item().questions.length}题`)
          .fontSize(13)
          .fontColor('#6B7280')
      }
      .width('100%')
      .margin({ top: 14 })
    }
    .width('100%')
    .padding(18)
    .backgroundColor(Color.White)
    .borderRadius(18)
    .shadow({ radius: 10, color: '#12000000', offsetY: 4 })
    .onClick(() => {
      this.onTap();
    })
  }
}
