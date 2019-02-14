# 프로젝트 세팅

안녕하세요. 개발자 여러분
개발 전 프로젝트 세팅 방법에 대한 안내입니다.


* bundle install

* rails db:create

* rails db:migrate

* bundle exec figaro install
(피가로 잼 설치 후, 저에게 각종 API 키 요청을 해주세요.)

* 개발 PC 에 minimagick 설치(이미지 업로드, 에디터 이미지 작업 등에 필요합니다.)

# 서버 배포 방법

- 특정 브랜치에서 배포할 경우

* bundle exec cap staging deploy BRANCH='브랜치 이름' => 테스트서버

* bundle exec cap production deploy => 실서버