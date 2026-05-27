// ?????????
import { SubjectInfo } from './QuestionTypes';

export const SUBJECTS: SubjectInfo[] = [
  { id: 'chinese', name: '??', icon: '??', color: '#FF6B6B' },
  { id: 'math', name: '??', icon: '??', color: '#4ECDC4' },
  { id: 'english', name: '??', icon: '??', color: '#FFD93D' },
  { id: 'physics', name: '??', icon: '??', color: '#A78BFA' },
  { id: 'chemistry', name: '??', icon: '??', color: '#34D399' },
  { id: 'biology', name: '??', icon: '??', color: '#FBBF24' },
  { id: 'politics', name: '??', icon: '??', color: '#60A5FA' },
  { id: 'history', name: '??', icon: '??', color: '#F472B6' },
  { id: 'geography', name: '??', icon: '??', color: '#22D3EE' }
];

export function getSubjectsByStage(stage: 'primary' | 'junior'): SubjectInfo[] {
  if (stage === 'primary') {
    return SUBJECTS.filter((subject: SubjectInfo) => subject.id === 'chinese' || subject.id === 'math' || subject.id === 'english');
  }
  return SUBJECTS;
}
