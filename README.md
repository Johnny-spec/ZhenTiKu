# 学霸题库 (ExamHelper)

为中小学生提供期中期末真题与解答思路的纯血鸿蒙 APP。

## 技术栈

- ArkTS
- ArkUI
- HarmonyOS NEXT / API 12+

## 目录结构

```text
.
├── AppScope/                         # 应用级配置与资源
├── entry/                            # 主 HAP 模块
│   └── src/main/
│       ├── ets/entryability/         # UIAbility 入口
│       ├── ets/entrybackupability/   # 备份恢复扩展
│       └── resources/base/           # 模块资源与页面配置
├── build-profile.json5               # 应用构建配置
├── hvigorfile.ts                     # 应用构建任务
└── oh-package.json5                  # 工程依赖配置
```

## 运行方式

1. 使用 DevEco Studio 5.0+ 打开项目目录。
2. 同步工程依赖与构建配置。
3. 选择 HarmonyOS 模拟器或真机。
4. 运行 `entry` 模块。

## 功能列表（占位）

- 年级选择
- 学科选择
- 真题列表
- 题目详情与解题思路
- 收藏题目
- 题库搜索
