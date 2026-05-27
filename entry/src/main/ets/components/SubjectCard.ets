import { SubjectInfo } from '../data/QuestionTypes';

interface SubjectView {
  id: string;
  name: string;
  icon?: string;
  emoji?: string;
}

@Component
export struct SubjectCard {
  @Prop subject: SubjectInfo;
  onTap: () => void = () => {};

  private iconText(): string {
    const item = this.subject as SubjectView;
    if (item.icon && item.icon.length > 0) {
      return item.icon;
    }
    if (item.emoji && item.emoji.length > 0) {
      return item.emoji;
    }
    return '📘';
  }

  private subjectName(): string {
    return (this.subject as SubjectView).name;
  }

  build() {
    Row() {
      Text(this.iconText())
        .fontSize(28)
        .textAlign(TextAlign.Center)
        .width(58)
        .height(58)
        .borderRadius(29)
        .backgroundColor('#EEF2FF')
        .padding({ top: 11 })
        .margin({ right: 16 })

      Text(this.subjectName())
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1F2937')
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text('›')
        .fontSize(28)
        .fontColor('#A0AEC0')
    }
    .width('100%')
    .height(86)
    .padding({ left: 18, right: 18 })
    .backgroundColor(Color.White)
    .borderRadius(18)
    .shadow({ radius: 12, color: '#14000000', offsetY: 4 })
    .onClick(() => {
      this.onTap();
    })
  }
}
