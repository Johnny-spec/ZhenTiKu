import router from '@ohos.router';
import { GradientHeader } from '../components/GradientHeader';
import { SubjectCard } from '../components/SubjectCard';
import { GradeInfo, SubjectInfo } from '../data/QuestionTypes';
import { GRADES } from '../data/Grades';
import { SUBJECTS, getSubjectsByStage } from '../data/Subjects';
import { getAllSubjectsForGrade } from '../data/QuestionBank';

interface RouteParams {
  gradeId?: string;
}

interface GradeView {
  id: string;
  name: string;
  stage: 'primary' | 'junior';
}

interface SubjectView {
  id: string;
  name: string;
}

@Entry
@Component
struct GradePage {
  @State gradeId: string = '';
  @State subjects: SubjectInfo[] = [];
  @State title: string = '选择学科';

  aboutToAppear(): void {
    const params = router.getParams() as RouteParams;
    this.gradeId = params.gradeId || '';
    this.loadSubjects();
  }

  private loadSubjects(): void {
    const grade = this.findGrade();
    if (grade) {
      this.title = (grade as GradeView).name;
      const stageSubjects = getSubjectsByStage((grade as GradeView).stage);
      const available = getAllSubjectsForGrade(this.gradeId) as Array<string | SubjectInfo>;
      this.subjects = stageSubjects.filter((subject: SubjectInfo) => {
        if (available.length === 0) {
          return true;
        }
        return available.some((item: string | SubjectInfo) => {
          if (typeof item === 'string') {
            return item === (subject as SubjectView).id;
          }
          return (item as SubjectView).id === (subject as SubjectView).id;
        });
      });
      if (this.subjects.length === 0) {
        this.subjects = SUBJECTS.filter((subject: SubjectInfo) => {
          return stageSubjects.some((item: SubjectInfo) => (item as SubjectView).id === (subject as SubjectView).id);
        });
      }
    }
  }

  private findGrade(): GradeInfo | undefined {
    return GRADES.find((grade: GradeInfo) => (grade as GradeView).id === this.gradeId);
  }

  private openSubject(subject: SubjectInfo): void {
    router.pushUrl({
      url: 'pages/SubjectPage',
      params: {
        gradeId: this.gradeId,
        subjectId: (subject as SubjectView).id
      }
    });
  }

  build() {
    Column() {
      GradientHeader({ title: this.title, showBack: true })

      List({ space: 14 }) {
        ForEach(this.subjects, (subject: SubjectInfo) => {
          ListItem() {
            SubjectCard({
              subject: subject,
              onTap: () => {
                this.openSubject(subject);
              }
            })
          }
        }, (subject: SubjectInfo) => (subject as SubjectView).id)
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
