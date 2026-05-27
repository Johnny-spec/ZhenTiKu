import router from '@ohos.router';
import { GradientHeader } from '../components/GradientHeader';
import { GradeInfo } from '../data/QuestionTypes';
import { GRADES } from '../data/Grades';

interface GradeView {
  id: string;
  name: string;
  stage: string;
}

@Entry
@Component
struct Index {
  @State currentTab: number = 0;

  private stageLabel(grade: GradeInfo): string {
    const stage = (grade as GradeView).stage;
    if (stage === 'primary') {
      return '小学';
    }
    return '初中';
  }

  private openGrade(grade: GradeInfo): void {
    router.pushUrl({
      url: 'pages/GradePage',
      params: { gradeId: (grade as GradeView).id }
    });
  }

  @Builder
  private HomeContent() {
    Column() {
      GradientHeader({ title: '学霸题库', showBack: false })

      Column() {
        Row() {
          Text('🔍')
            .fontSize(20)
            .margin({ right: 8 })
          Text('搜索题目、知识点')
            .fontSize(15)
            .fontColor('#9CA3AF')
            .layoutWeight(1)
        }
        .width('100%')
        .height(48)
        .padding({ left: 16, right: 16 })
        .backgroundColor(Color.White)
        .borderRadius(24)
        .onClick(() => {
          router.pushUrl({ url: 'pages/SearchPage' });
        })

        Text('选择年级')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111827')
          .width('100%')
          .margin({ top: 26, bottom: 14 })

        Grid() {
          ForEach(GRADES, (grade: GradeInfo) => {
            GridItem() {
              Column() {
                Text((grade as GradeView).name)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#1F2937')
                Text(this.stageLabel(grade))
                  .fontSize(12)
                  .fontColor('#5B7CFF')
                  .margin({ top: 8 })
                  .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                  .backgroundColor('#EEF2FF')
                  .borderRadius(12)
              }
              .width('100%')
              .height(104)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(Color.White)
              .borderRadius(18)
              .shadow({ radius: 10, color: '#10000000', offsetY: 4 })
              .onClick(() => {
                this.openGrade(grade);
              })
            }
          }, (grade: GradeInfo) => (grade as GradeView).id)
        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(14)
        .rowsGap(14)
        .width('100%')
      }
      .padding(18)
      .layoutWeight(1)
      .backgroundColor('#F6F7FB')
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        this.HomeContent()
      }
      .tabBar('首页')

      TabContent() {
        Column() {
          Text('收藏')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Button('查看我的收藏')
            .margin({ top: 16 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/FavoritesPage' });
            })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#F6F7FB')
      }
      .tabBar('收藏')

      TabContent() {
        Column() {
          Text('我的')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
          Text('更多功能敬请期待')
            .fontSize(15)
            .fontColor('#6B7280')
            .margin({ top: 10 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#F6F7FB')
      }
      .tabBar('我的')
    }
    .barMode(BarMode.Fixed)
    .onChange((index: number) => {
      this.currentTab = index;
    })
  }
}
