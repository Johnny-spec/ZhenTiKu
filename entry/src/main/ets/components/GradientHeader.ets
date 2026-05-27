import router from '@ohos.router';

@Component
export struct GradientHeader {
  @Prop title: string = '';
  @Prop showBack: boolean = false;

  private startColor(): string {
    return '#5B7CFF';
  }

  private endColor(): string {
    return '#8B5CF6';
  }

  private maskColor(): string {
    return 'rgba(255,255,255,0.20)';
  }

  private headerHeight(): number {
    return 96;
  }

  build() {
    Row() {
      if (this.showBack) {
        Button({ type: ButtonType.Circle }) {
          Text('‹')
            .fontSize(30)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .lineHeight(32)
        }
        .width(42)
        .height(42)
        .backgroundColor(this.maskColor())
        .onClick(() => {
          router.back();
        })
        .margin({ right: 12 })
      } else {
        Blank()
          .width(0)
      }

      Text(this.title)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      if (this.showBack) {
        Blank()
          .width(42)
      }
    }
    .width('100%')
    .height(this.headerHeight())
    .padding({ left: 20, right: 20, top: 28 })
    .linearGradient({
      angle: 135,
      colors: [[this.startColor(), 0.0], [this.endColor(), 1.0]]
    })
  }
}
