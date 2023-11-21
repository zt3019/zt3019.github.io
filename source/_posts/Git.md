---
title: Git
date: 2023-11-16 18:02:28
tags:
- git
categories: 
- git
index_img: https://tse2-mm.cn.bing.net/th/id/OIP-C.R1Bi3fNDyYjLsXdg9OqoIAHaEo?rs=1&pid=ImgDetMain
banner_img: https://tse2-mm.cn.bing.net/th/id/OIP-C.R1Bi3fNDyYjLsXdg9OqoIAHaEo?rs=1&pid=ImgDetMain
---

# Git

## 简介

- [git学习网站(参考该教程学习并写的博客)](https://www.liaoxuefeng.com/wiki/896043488029600/897271968352576)

* 分布式版本控制系统
* Linux之父Linus Torvalds两周用C写了一个分布式版本控制系统，一个月内Linux 系统的源码已经由Git管理了。这就是鸡欧帝的实力吗？亏贼！
* 集中式版本控制系统和分布式版本控制系统的区别
  - 本质区别：你的本地是否有完整的版本库历史。
    - 假设SVN服务器消失了，你失去了所有的历史信息，因为你的本地只有当前版本以及部分历史信息。
    - 假设Github服务器消失了，你不会丢掉任何git历史信息，因为你的本地有完整的版本库信息，你可以把本地的git库重新上传到其他的git服务器上去。
  - 集中式版本控制器很依赖中央服务器，需要网络，当网络不好时，每次拉取，提交文件非常缓慢。

## 安装

* linux:sudo apt-get install git
* mac:安装一个Xcode
* windows:安装一个gitbash

## 基本使用

* 创建一个目录

  ````bash
  $ mkdir learngit
  $ cd learngit
  $ pwd
  /Users/michael/learngit
  ````

* git init   通过`git init`命令把这个目录变成Git可以管理的仓库：

  ````bash
  $ git init
  Initialized empty Git repository in /Users/michael/learngit/.git/
  ````

* 之后可以在此目录下创建文件

* 把一个文件放入git仓库分为两步

  - **git add** 命令，把文件添加到仓库

  - **git commit** 命令，把文件提交到仓库  -m "注释"。-m""后面输入本次提交的说明

    ````bash
    $ git add readme.txt
    $ git commit -m "wrote a readme file"
    [master (root-commit) eaadf4e] wrote a readme file
     1 file changed, 2 insertions(+)
     create mode 100644 readme.txt
    ````

### 版本管理

* **git status** 命令可以查看仓库当前的状态（可以知道文件是否有修改）

* **git diff + 文件名** 命令可以查看当前文件和仓库中文件的差异（查看修改的内容）

#### 版本回退

* **git log**  命令显示从近到最远的提交日志
  - **git log --pretty=oneline**   加上参数后，会精简输出内容
* **git reset**  回退版本
  - **git reset --hard HEAD^**  表示回退到前一个版本，**HEAD^**代表前一个版本，**HEAD^^**代表前两个版本，以此类推
  - **git reset --hard HEAD~100**   回退版本，数字代表回退到前多少个版本
  - **git reset --hard 1094a**  加上版本号的前几位即可，会回退到指定的版本
* **git reflog**  查看命令历史
  -  可以通过查看命令历史，重返未来的某个版本。（对于当前版本来说是未来，因为当前版本是从未来某个版本回退回来的）

#### 工作区和暂存区

* 工作区

  - 在git仓库中目前的文件，就是工作区

* 版本库

  - 工作区目录下有一个隐藏文件**.git**，是git的版本库

  - git版本库中最重要的就是**stage(index)**暂存区，git自动创建的一个**master**，以及指向**master**的一个指针叫**HEAD**

    ![版本库](https://www.liaoxuefeng.com/files/attachments/919020037470528/0)

  * git add命令就是把提交的所有修改放到暂存区(stage)，git commit 命令就是一次性把暂存区的所有修改提交至版本库(master)

  * 查看工作区和版本库中最新版本的区别：

    ````bash
    git diff HEAD -- readme.txt
    ````

  * ````bash
    # git reset命令既可以回退版本，也可以把暂存区的修改回退到工作区。当我们用HEAD时，表示最新的版本。
    git reset HEAD readme.txt
    # 丢弃工作区的修改
    git checkout -- readme.txt
    #git checkout其实是用版本库里的版本替换工作区的版本，无论工作区是修改还是删除，都可以“一键还原”。
    # 删除文件，然后commit文件就删除了
    rm test.txt
    
    ````

  ### 远程仓库

  * 采用github作为远程在线的git服务器

  * 注册一个github账号，本地git仓库和github仓库之间的传输是通过SSH加密的

  * 步骤

    ````bash
    #第1步：创建SSH Key。在用户主目录下，看看有没有.ssh目录，如果有，再看看这个目录下有没有id_rsa和#id_rsa.pub这两个文件。有的话也可以删掉重新创建ssh key。如果没有，打开Shell（Windows下打开Git #Bash），创建SSH Key：
    ssh-keygen -t rsa -C "youremail@example.com"
    
    #第二步：在github中将公钥id_rsa.pub的内容添加
    
    #为什么GitHub需要SSH Key呢？因为GitHub需要识别出你推送的提交确实是你推送的，而不是别人冒充的，而Git支持SSH协议，所以，GitHub只要知道了你的公钥，就可以确认只有你自己才能推送。
    
    #当然，GitHub允许你添加多个Key。假定你有若干电脑，你一会儿在公司提交，一会儿在家里提交，只要把每台电脑的Key都添加到GitHub，就可以在每台电脑上往GitHub推送了。
    
    #最后友情提示，在GitHub上免费托管的Git仓库，任何人都可以看到喔（但只有你自己才能改）。所以，不要把敏感信息放进去。
    
    #如果你不想让别人看到Git库，有两个办法，一个是交点保护费，让GitHub把公开的仓库变成私有的，这样别人就看不见了（不可读更不可写）。另一个办法是自己动手，搭一个Git服务器，因为是你自己的Git服务器，所以别人也是看不见的。这个方法我们后面会讲到的，相当简单，公司内部开发必备。
    
    #确保你拥有一个GitHub账号后，我们就即将开始远程仓库的学习。
    ````

  * ![](D:\图片\gtihub添加ssh公钥.png)

#### 添加远程库

* 如果你在本地建好了一个git仓库后，想在github上新建一个git仓库，并且可以实现两个仓库之间的远程同步

  - 第一步：在github创建一个仓库

  - 第二步：和新创建的远程github仓库进行关联

    - ````bash
      git remote add origin git@github.com:zt3019/learngit.git
      ````

  - 第三步：将本地库的所有内容推送到远程库上

    - ````bash
      #添加关联后，远程库的名字叫origin，这是git的默认叫法，也可以修改
      git push -u origin master
      #由于远程库是空的，我们第一次推送master分支时，加上了-u参数，Git不但会把本地的master分支内容推送的远程新的master分支，还会把本地的master分支和远程的master分支关联起来，在以后的推送或者拉取时就可以简化命令。
      ````

  - 在这之后，需要提交代码到远程库只需要执行push命令

    - ```bash
      git push origin master
      #查看远程库信息
      git remote -v
      #删除远程库
      git remote rm origin
      
      ```

#### 从远程库克隆

* 如果是先创建远程库，然后从远程库克隆

  - 先登录远程库，如github，创建一个新的仓库

  - 远程库创建好之后，用git clone克隆一个本地库

    ````bash
    git clone git@github.com:zt3019/gitskills.git
    ````

  - 之后就可以在本地看到创建的gitskills仓库了

* Git支持多种协议，包括`https`，但`ssh`协议速度最快。

### 分支管理

* 分支在实际中有什么用呢？假设你准备开发一个新功能，但是需要两周才能完成，第一周你写了50%的代码，如果立刻提交，由于代码还没写完，不完整的代码库会导致别人不能干活了。如果等代码全部写完再一次提交，又存在丢失每天进度的巨大风险。

  现在有了分支，就不用怕了。你创建了一个属于你自己的分支，别人看不到，还继续在原来的分支上正常工作，而你在自己的分支上干活，想提交就提交，直到开发完毕后，再一次性合并到原来的分支上，这样，既安全，又不影响别人工作。

* 每次提交，git都把他们串成一条时间线，这条时间线就是一个分支。主分支即**master**分支，**HEAD**严格来说不是指向提交，而是指向**master**，**master**才是指向提交的，所以，**HEAD**指向的就是当前分支。

* 例如：git新增一个dev分支，git创建了一个指针叫dev，指向master相同的提交，再把`HEAD`指向`dev`，就表示当前分支在dev上。如果在dev上操作完成之后，将`dev`合并到`master`，将`master`指向`dev`当前的提交，就完成了合并。所以git合并分支非常快，修改一下指针的指向。合并完成后，我们可以删除`dev`分支，而删除`dev`分支就是把`dev`指针给删掉，删掉后，我们就剩下了一条`master`分支

* [廖雪峰的官方网站中的git教程](https://www.liaoxuefeng.com/wiki/896043488029600/900003767775424)

* 实操：

  - 第一步：创建`dev`分支

    - ````bash
      git switch -c dev
      #git checkout命令加上-b参数表示创建并切换,相当于下面两条语句:
      git branch dev
      git switch dev
      #使用git branch命令查看当前分支
      git branch
      ````

  - 第二步：切换到`dev`分支后，在`dev`分支修改文件内容

    - ```bash
      #在dev分支修改git文件内容之后，提交修改的文件
      git add readme.txt
      git commit -m "branch test"
      
      # 切换回master分支，我们无法看到刚才修改的内容，因为刚才的添加提交是在dev分支上的
      git switch master
      
      ```

    - 

  - 第三步：把`dev`分支的工作成果合并到`master`分支上

    - ````bash
      #git merge命令用于合并指定分支到当前分支。合并后，再查看readme.txt的内容，就可以看到，和dev分支的最新提交是完全一样的。
      git merge dev
      #合并完成后，我们可以在master分支上看到刚才修改的内容，然后就可以删除dev分支了
      git branch -d dev
      ````

    - 因为创建、合并和删除分支非常快，所以Git鼓励你使用分支完成某个任务，合并后再删掉分支，这和直接在master分支上工作效果是一样的，但过程更安全。

  - 建议使用git switch来切换分支，更易于理解

#### 解决分支冲突

* 分支合并是有可能会出现分支冲突的，比如下面的一个案例

  - 创建一个新的分支，修改文件内容，进行add并commit

    - ````bash
      #创建feature分支并切换到该分支
      git switch -c feature
      #修改readme.txt文件内容，添加一行：creating a new branch named feature
      #然后添加到暂存区并提交
      git add readme.txt
      git commit -m "new a branch named feature1"
      ````

  - 切换到master分支，也修改文件内容，进行add并commit

    - ````bash
      #切换分支
      git switch master
      #修改readme.txt文件内容，添加一行：分支冲突吧你
      #然后添加到暂存区并提交
      git add readme.txt
      git commit -m "add chinese"
      ````

  - 在master进行合并，将feature分支合并进来

    - ````bash
      #合并分支
      git merge feature
      ````

    - 两个分支都对readme.txt文件内容进行了不同的修改，无法进行快速合并，git会发出报错信息，`readme.txt`文件存在冲突，必须手动解决冲突之后再提交。git status可以查看到冲突的文件。

    - ![分支冲突](D:\图片\分支冲突.png)

  - 出现冲突之后，我们需要解决冲突

    - ````bash
      vim readme.txt
      #Git用<<<<<<<，=======，>>>>>>>标记出不同分支的内容
      #重新编辑冲突了的文件，保留你需要的内容，去除冲突的部分
      #然后重新add,commit
      git add readme.txt 
      git commit -m "conflict fixed"
      #git会显示"conflict fixed"
      ````

  - 最后工作

    - ````bash
      #从git提交的分支图可以看到我们解决分支冲突的过程
      git log --graph --pretty=oneline --abbrev-commit
      
      #最后，我们可以将feature分支删除
      git branch -d feature
      ````

    - ![](D:\图片\git分支图.png)

#### 分支管理策略

* 一般情况下，合并分支时，git会使用`fast forward`模式,这种模式下，删除分支后，会丢掉分支信息

* 如果要强制禁用`Fast forward`模式，Git就会在merge时生成一个新的commit，这样，从分支历史上就可以看出分支信息。

* [关于分支管理策略的参考博客](https://www.liaoxuefeng.com/wiki/896043488029600/900005860592480)

* 通过一个案例来演示：

  - ````bash
    #创建并切换dev分支
    git switch -c dev
    #修改readme.txt文件内容并提交
    git add readme.txt 
    git commit -m "add merge"
    #切换回master
    git switch master
    #回到master分支之后，合并dev分支,使用--no-ff参数，表示禁用Fast forward
    git merge --no-ff -m "merge with no-ff" dev
    #再查看git提交的分支树
    git log --graph --pretty=oneline --abbrev-commit
    ````

  - ![](D:\图片\分支策略.png)

#### Bug分支

- 我们在开发过程中，遇到了bug，我们可以通过创建一个新的临时分支来修复，修复之后，合并分支，然后将临时分支删除。举个栗子：

  - 当我们收到一个修复bug的任务，我们创建一个`issue-3208`来修复它，但是我们在dev分支上进行的工作只完成了一半，不能够提交。而且我们必须先解决bug

    - ````bash
      #stash功能，可以把当前工作现场储存起来，等后续恢复现场后继续工作
      git status
      #执行status命令之后，再用git status查看工作区，就是干净的
      #首先要确定是在哪个分支上修复bug,例如需要在master分支上修复
      git switch master
      
      #在master分支上创建临时修复bug的分支
      git switch -c issue-3208
      
      
      #在新建的分支修复bug，修复完成之后，进行add&commit
      git add readme.txt
      git commit -m "fix bug 3208"
      
      #修复完成之后，切换到master分支，并完成合并，最后删除issue-3208分支
      git switch master
      
      git merge --no-ff -m "merged bug fix 3208" issue-101
      
      #完成bug修复之后，继续回到dev分支干活
      git switch dev
      
      #通过git status 命令发现工作区是干净的
      #通过stash list 命令查看，隐藏的工作区
      git stash list 
      
      #一是用git stash apply恢复，但是恢复后，stash内容并不删除，你需要用git stash drop来删除；
      #另一种方式是用git stash pop，恢复的同时把stash内容也删了：
      git stash pop
      
      #可以进行多次stash，恢复的时候，先查看git stash list 的列表，然后恢复指定的stash
      git stash apply stash@{0}
      
      #在master分支上修复的bug，想要合并到当前dev分支，可以用git cherry-pick <commit>命令，把bug提交的修改“复制”到当前分支，避免重复劳动。
      ````

    - 

#### Feature分支

* 在开发中，有新功能进来的时候，创建一个feature分支，在上面开发完成之后合并，最终删除该分支

  - ````bash
    #开发一个新需求
    git switch -c feature-vulcan
    
    #开发完成后进行add&commit
    
    #之后应该切换到dev并进行合并，然后删除新建的分支
    
    #新需求砍掉了
    git branch -D feature-vulcan
    
    #-D参数强行删除
    ````

  - 如果要丢弃一个没有被合并过的分支，可以通过`git branch -D <name>`强行删除。

#### 多人协作

* 当你从远程仓库克隆时，git自动把本地的`master`分支和远程的`master`分支对应起来了，并且远程仓库的默认名称是`origin`。

  - ````bash
    # 查看远程库的详细信息
    git remote -v
    #上面显示了可以抓取和推送的origin的地址。如果没有推送权限，就看不到push的地址。
    #推送分支，就是把该分支上的所有本地提交到远程库，推送时，要指定本地分支，git就会把该分支推送到远程库对应的远程分支上
    git push origin master
    git push origin dev
    
    ````

  - `master`分支是主分支，因此要时刻与远程同步；

  - `dev`分支是开发分支，团队所有成员都需要在上面工作，所以也需要与远程同步；

  - bug分支只用于在本地修复bug，就没必要推到远程了，除非老板要看看你每周到底修复了几个bug；

  - feature分支是否推到远程，取决于你是否和你的小伙伴合作在上面开发。

* 因此，多人协作的工作模式通常是这样：

  1. 首先，可以试图用`git push origin <branch-name>`推送自己的修改；
  2. 如果推送失败，则因为远程分支比你的本地更新，需要先用`git pull`试图合并；
  3. 如果合并有冲突，则解决冲突，并在本地提交；
  4. 没有冲突或者解决掉冲突后，再用`git push origin <branch-name>`推送就能成功！

  如果`git pull`提示`no tracking information`，则说明本地分支和远程分支的链接关系没有创建，用命令`git branch --set-upstream-to <branch-name> origin/<branch-name>`。

  这就是多人协作的工作模式，一旦熟悉了，就非常简单。

#### Rebase

* rebase操作可以把本地未push的分叉提交历史整理成直线；
* rebase的目的是使得我们在查看历史提交的变化时更容易，因为分叉的提交需要三方对比。
* [https://www.liaoxuefeng.com/wiki/896043488029600/1216289527823648](rebase描述)

### 标签管理

#### 创建标签

* 发布一个版本时，通常现在版本库中打一个标签（tag），这样就确定了打标签时刻的版本。标签就是版本库的一个快照。commit号太长了，不方便寻找，使用标签号进行提交发版，更加清晰明了。

* 打标签

  - ````bash
    #切换到需要打标签的分支上
    git switch master
    #git tag <name>命令打上标签,不加名字可以查看标签
    git tag v1.0
    #默认标签是打在最新提交的commit上的，要为之前的commit打上标签，需要找到commit id
    git tagv0.9 5f23208
    
    # git 命令查看标签，不是按时间顺序列出，而是按照字母排序的
    git tag
    #使用git show <tagname>查看标签详细信息
    git show v1.0
    
    #创建带有说明的标签，用-a指定标签名，-m指定说明文字
    git tag -a v0.1 -m "version 0.1 released" 4d39864
    
    ````

  - 标签总是和某个commit挂钩。如果这个commit既出现在master分支，又出现在dev分支，那么在这两个分支上都可以看到这个标签。

#### 操作标签

- 可以删除标签，推送标签至远程

  - ````bash
    #删除标签
    git tag -d v0.1
    
    #推送某个标签到远程
    git push origin v1.0
    #一次性推送全部尚未推送到远程的本地标签
    git push origin --tags
    
    #如果标签已经推送至远程库，删除远程标签需要两步，先删除本地，再删除远程
    git tag -d v0.9
    
    git push origin -d tag v0.9
    #之后可以去远程库查看标签是否已经删除
    
    ````



### 远程仓库

* 在GitHub上，可以任意Fork开源仓库；
* 自己拥有Fork后的仓库的读写权限；
* 可以推送pull request给官方仓库来贡献代码。
* gitee国内的git托管服务商，有中文，不容易出现网络问题



### 通用配置

* 有时候一些隐私文件也在git工作目录中，但是不能提交他们。比如保存了数据库密码的配置文件

* 可以在Git工作区的根目录下创建一个特殊的`.gitignore`文件，然后把要忽略的文件名填进去，Git就会自动忽略这些文件。

* 忽略文件的原则是：

  1. 忽略操作系统自动生成的文件，比如缩略图等；
  2. 忽略编译生成的中间文件、可执行文件等，也就是如果一个文件是通过另一个文件自动生成的，那自动生成的文件就没必要放进版本库，比如Java编译产生的`.class`文件；
  3. 忽略你自己的带有敏感信息的配置文件，比如存放口令的配置文件。

* 不需要从头写`.gitignore`文件，GitHub已经为我们准备了各种配置文件，只需要组合一下就可以使用了。所有配置文件可以直接在线浏览：https://github.com/github/gitignore

* ````bash
  #强制添加文件到git
  git add -f App.class
  #或者你发现，可能是.gitignore写得有问题，需要找出来到底哪个规则写错了，可以用git check-ignore命令检查
  git check-ignore -v App.class
  ````

* 把指定文件排除在`.gitignore`规则外的写法就是`!`+文件名，所以，只需把例外文件添加进去即可。

* 忽略某些文件时，需要编写`.gitignore`；

* `.gitignore`文件本身要放到版本库里，并且可以对`.gitignore`做版本管理！

* 可以给git命令设置简称

  - ````bash
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.ci commit
    git config --global alias.br branch
    #--global参数是全局参数，也就是这些命令在这台电脑的所有Git仓库下都有用
    git config --global alias.unstage 'reset HEAD'
    #执行上面的命令之后
    git unstage test.py == git reset HEAD test.py
    
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    
    git lg
    ````

  - 每个仓库的Git配置文件都放在`.git/config`文件中

  - 别名就在`[alias]`后面，要删除别名，直接把对应的行删掉即可。

  - 而当前用户的Git配置文件放在用户主目录下的一个隐藏文件`.gitconfig`中

  - 配置别名也可以直接修改这个文件，如果改错了，可以删掉文件重新通过命令配置。

