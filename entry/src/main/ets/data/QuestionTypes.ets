// 题库相关类型定义
export enum QuestionType {
  CHOICE = 'choice',
  FILL = 'fill',
  SOLVE = 'solve'
}

export enum ExamType {
  MIDTERM = 'midterm',
  FINAL = 'final'
}

export interface Question {
  id: string;
  type: QuestionType;
  stem: string;
  options?: string[];
  answer: string;
  analysis: string;
  knowledge?: string;
}

export interface Paper {
  id: string;
  grade: string;
  subject: string;
  examType: ExamType;
  year: number;
  title: string;
  questions: Question[];
}

export interface GradeInfo {
  id: string;
  name: string;
  stage: 'primary' | 'junior';
}

export interface SubjectInfo {
  id: string;
  name: string;
  icon: string;
  color: string;
}