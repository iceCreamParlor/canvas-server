# 프로젝트 세팅

안녕하세요. 개발자 여러분
개발 전 프로젝트 세팅 방법에 대한 안내입니다.


* bundle install

* rails db:create

* rails db:migrate

* bundle exec figaro install
(피가로 잼 설치 후, 저에게 각종 API 키 요청을 해주세요.)

* 개발 PC 에 minimagick 설치(이미지 업로드, 에디터 이미지 작업 등에 필요합니다.)


# 브랜치 관리

- 각 개발자님들은 각자의 이름으로 브랜치 하나씩 생성해 주세요.
  (규모가 작은 개발 팀이기 때문에, 이 방식이 효율적이라고 판단하였습니다.)
- 개인용 브랜치는 테스트서버 / 실서버 반영 금지 !
- 실서버에 반영하는 브랜치는 master 브랜치 / 테스트서버에 반영하는 브랜치는 develop 브랜치입니다.
- 개인용 브랜치에서 작업하신 후, develop / master 브랜치에 merge 한 후 서버 배포해주세요.


# 서버 배포 방법

- 특정 브랜치에서 배포할 경우

* bundle exec cap staging deploy BRANCH='develop' => 테스트서버

* bundle exec cap production deploy => 실서버

# Imagemagick 설치되어 있어야 기능이 정상적으로 작동합니다.

# 실서버 배포 시 주의 사항

* 메일 관련 기능 수정 후 실서버 / 테스트서버 배포했을 때, delayed_job 을 restart 해 주어야 합니다.
```console
  $ RAILS_ENV=production bin/delayed_job restart (start / stop)
```
* (개발 환경에서 async 작업 테스트할때)
```console
  $ rails jobs:work
```