import router from '@ohos.router';
import { GradientHeader } from '../components/GradientHeader';
import { PaperItem } from '../components/PaperItem';
import { ExamType, GradeInfo, Paper, SubjectInfo } from '../data/QuestionTypes';
import { GRADES } from '../data/Grades';
import { SUBJECTS } from '../data/Subjects';
import { getPapers } from '../data/QuestionBank';

interface RouteParams {
  gradeId?: string;
  subjectId?: string;
}

interface IdNameView {
  id: string;
  name: string;
}

interface PaperView {
  id: string;
  title: string;
  examType: ExamType | string;
}

@Entry
@Component
struct SubjectPage {
  @State gradeId: string = '';
  @State subjectId: string = '';
  @State title: string = '试卷列表';
  @State midPapers: Paper[] = [];
  @State finalPapers: Paper[] = [];

  aboutToAppear(): void {
    const params = router.getParams() as RouteParams;
    this.gradeId = params.gradeId || '';
    this.subjectId = params.subjectId || '';
    this.loadPapers();
  }

  private loadPapers(): void {
    const grade = GRADES.find((item: GradeInfo) => (item as IdNameView).id === this.gradeId);
    const subject = SUBJECTS.find((item: SubjectInfo) => (item as IdNameView).id === this.subjectId);
    if (grade && subject) {
      this.title = `${(grade as IdNameView).name} - ${(subject as IdNameView).name}`;
    }
    const papers = getPapers(this.gradeId, this.subjectId);
    this.midPapers = papers.filter((paper: Paper) => this.isMid(paper));
    this.finalPapers = papers.filter((paper: Paper) => !this.isMid(paper));
  }

  private isMid(paper: Paper): boolean {
    const exam = String((paper as PaperView).examType).toLowerCase();
    return exam.indexOf('mid') >= 0 || exam.indexOf('期中') >= 0;
  }

  private openPaper(paper: Paper): void {
    router.pushUrl({
      url: 'pages/PaperListPage',
      params: { paperId: (paper as PaperView).id }
    });
  }

  @Builder
  private PaperList(papers: Paper[]) {
    List({ space: 14 }) {
      ForEach(papers, (paper: Paper) => {
        ListItem() {
          PaperItem({
            paper: paper,
            onTap: () => {
              this.openPaper(paper);
            }
          })
        }
      }, (paper: Paper) => (paper as PaperView).id)
    }
    .width('100%')
    .height('100%')
    .padding(18)
    .backgroundColor('#F6F7FB')
  }

  build() {
    Column() {
      GradientHeader({ title: this.title, showBack: true })

      Tabs() {
        TabContent() {
          this.PaperList(this.midPapers)
        }
        .tabBar('期中')

        TabContent() {
          this.PaperList(this.finalPapers)
        }
        .tabBar('期末')
      }
      .layoutWeight(1)
      .barMode(BarMode.Fixed)
      .backgroundColor('#F6F7FB')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F7FB')
  }
}
