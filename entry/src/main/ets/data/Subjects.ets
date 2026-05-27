// 学科常量定义（小学 3 科，初中扩展 9 科）
import { SubjectInfo } from './QuestionTypes';

export const SUBJECTS: SubjectInfo[] = [
  { id: 'chinese', name: '语文', icon: '📖', color: '#FF6B6B' },
  { id: 'math', name: '数学', icon: '🔢', color: '#4ECDC4' },
  { id: 'english', name: '英语', icon: '🔤', color: '#FFD93D' },
  { id: 'physics', name: '物理', icon: '⚗️', color: '#A78BFA' },
  { id: 'chemistry', name: '化学', icon: '🧪', color: '#34D399' },
  { id: 'biology', name: '生物', icon: '🌱', color: '#FBBF24' },
  { id: 'politics', name: '政治', icon: '⚖️', color: '#60A5FA' },
  { id: 'history', name: '历史', icon: '📜', color: '#F472B6' },
  { id: 'geography', name: '地理', icon: '🌍', color: '#22D3EE' }
];

export function getSubjectsByStage(stage: 'primary' | 'junior'): SubjectInfo[] {
  if (stage === 'primary') {
    return SUBJECTS.filter((subject: SubjectInfo) =>
      subject.id === 'chinese' || subject.id === 'math' || subject.id === 'english'
    );
  }
  return SUBJECTS;
}