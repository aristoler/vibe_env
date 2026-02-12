#!/bin/bash

# 使用当前目录名作为会话名，实现多项目隔离
DIR_NAME=$(basename "$PWD")
SESSION="$DIR_NAME"
# 核心逻辑修改：如果没传参数，默认使用 dev 布局
LAYOUT=${1:-vibe}
RESET=$2

# 检查是否安装了 tmux
if ! command -v tmux &>/dev/null; then
  echo "❌ Error: Tmux not installed."
  exit 1
fi

# 如果指定了 --reset，先杀掉旧会话
if [ "$RESET" == "--reset" ]; then
  echo "🔥 Force resetting session '$SESSION'..."
  tmux kill-session -t $SESSION 2>/dev/null
fi

# 核心逻辑修改：如果 Session 存在，直接连进去，绝不乱切分！
tmux has-session -t $SESSION 2>/dev/null

if [ $? == 0 ]; then
  echo "🔄 Session '$SESSION' already exists. Attaching..."
  tmux attach-session -t $SESSION
  exit 0
fi

# 如果走到这里，说明 Session 不存在，开始新建
echo "✨ Creating new session: $SESSION ($LAYOUT)"
# 创建会话，并指定窗口大小以避免 "size missing" 错误 (假设标准大小)
tmux new-session -d -s $SESSION -n "Editor" -x 200 -y 50
sleep 0.5 # 给 Tmux 一点启动时间

# 根据选择的布局进行切分
if [ "$LAYOUT" == "dev" ]; then
  # Dev 布局: 左 70% | 右 30%
  # 恢复 0-indexed 逻辑
  tmux send-keys -t $SESSION:Editor "nvim ." C-m

  # 切分出右侧面板 (.1)
  tmux split-window -h -t $SESSION:Editor -l 30%
  sleep 0.1
  tmux send-keys -t $SESSION:Editor.1 "ls -la" C-m

  # 切分出右下角面板 (.2)
  tmux split-window -v -t $SESSION:Editor.1 -l 50%
  sleep 0.1
  tmux send-keys -t $SESSION:Editor.2 "lazygit" C-m

  # 回到左侧主编辑器 (.0)
  tmux select-pane -t $SESSION:Editor.0

elif [ "$LAYOUT" == "debug" ]; then
  tmux send-keys -t $SESSION:Editor "nvim ." C-m
  tmux split-window -v -t $SESSION:Editor -l 20%
  sleep 0.1
  # 新面板是 .1
  tmux send-keys -t $SESSION:Editor.1 "htop" C-m
  # 回到 .0
  tmux select-pane -t $SESSION:Editor.0

elif [ "$LAYOUT" == "zen" ]; then
  tmux send-keys -t $SESSION:Editor "nvim ." C-m
elif [ "$LAYOUT" == "vibe" ]; then
  # Window 0: Editor + ai
  tmux send-keys -t "$SESSION:Editor.0" "nvim ." C-m
  
  # Window 1: vibe
  tmux new-window -t "$SESSION" -n "Vibe"
  tmux split-window -h -t "$SESSION:Vibe" -l 30%
  tmux split-window -v -t "$SESSION:Vibe" -l 50%
  
  # Window 2: Git + note
  tmux new-window -t "$SESSION" -n "Git"

  tmux send-keys -t "$SESSION:Git.0" "[ -d .git ] && lazygit || echo 'No Git Repository'" C-m
  
  tmux new-window -t "$SESSION" -n "Shell"
  tmux split-window -v -t "$SESSION:Shell" -l 30%

  # --- 6. 最终归位 ---
  tmux select-window -t "$SESSION:Editor"
  tmux select-pane -t "$SESSION:Editor.0"
fi

tmux attach-session -t $SESSION
