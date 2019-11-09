//
//  MockPosterService.swift
//  SsgSag
//
//  Created by 이혜주 on 09/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class MockPosterServiceImp: PosterService {
    func requestSwipePosters(completionHandler: @escaping (DataResponse<PosterData>) -> Void) {
        let mockPoster = Poster(posterIdx: 1,
               categoryIdx: 0,
               subCategoryIdx: 0,
               photoUrl: "https://s3.ap-northeast-2.amazonaws.com/project-hs/b95085abde0a45b8bb044cc1edbceb0b.png",
               posterName: "2019 에스원아이디어 공모전",
               posterRegDate: "2019-01-22 00:35:49",
               posterStartDate: "2019-01-22 00:35:49",
               posterEndDate: "2019-02-11 23:59:59",
               posterWebSite: "www.s1-idea.co.kr",
               isSeek: 0,
               outline: "mocking",
               target: "target",
               period: "period",
               benefit: "benefit",
               documentDate: "23:59",
               contentIdx: 200,
               hostIdx: 20000,
               posterDetail: "detail",
               posterInterest: [0],
               dday: 7,
               adminAccept: 1,
               keyword: "keyword",
               favoriteNum: 0,
               likeNum: 4)
        /*
         "posterIdx": 1,
         "categoryIdx": 0, //카테고리 분류, 0은 공모전, 1은 대외활동, 2는 동아리, 3은 교내공지, 4는 채용, 5는 기타
         + "subCategoryIdx": 0 //소분류
         "photoUrl": "https://s3.ap-northeast-2.amazonaws.com/project-hs/b95085abde0a45b8bb044cc1edbceb0b.png",
         "thumbPhotoUrl" : "https://project-hs.s3.ap-northeast-2.amazonaws.com/85849fa4b8f2379d7a49013da5694855-thumbnail",
         "photoUrl2": "https://s3.ap-northeast-2.amazonaws.com/project-hs/b95085abde0a45b8bb044cc1edbceb0b.png", //상세이미지 주소
         "posterName": "2019 에스원아이디어 공모전",
         "posterRegDate": "2019-01-22 00:35:49",
         "posterStartDate": "2018-11-19 00:00:00", //접수 시작날짜
         "posterEndDate": "2019-02-11 23:59:59", //접수 마감날짜
         "posterWebSite": "www.s1-idea.co.kr",
         "posterWebSite2": "www.s1-idea.co.kr",
         //"isSeek": 0, //채용포스터인지 일반포스터면 0, 채용포스터면 1
         "outline": "언제나 안심 <에스원> 에서 모두가 안심할 수 있는 첨단 미래를 만들기 위한 <2019 에스원 아이디어 공모전>을 개최합니다.", //포스터 개요나 주제
         "target": "국내 거주 대학(원)생 또는 일반인, 팀 지원 시 3인 이내 구성", //지원자격 및 타겟층
         "period": "3월중", //활동기간
         "benefit": "대상(1명/팀): 500만원/ 최우수상(2명/팀): 각 300만원 / 우수상(3명/팀): 각 100만원 / 장려상(4명/팀): 각 50만원 (※ 우수 작품이 없을 시 상금, 상격 및 수상인원 등은 변동 될 수 있습니다.)", //시상내역, 상금 및 이익
         "documentDate": "23:59", //지원마감시간
         "contentIdx": 200, //공모전이나 대외활동일 때 내용분류, 200은 공모전/경진대회, 201은 서포터즈, 202는 해외탐방, 203은 봉사단, 204는 기자단, 205는 강연, 206은 멘토링, 207은 행사/페스티벌, 208은 캠프, 209는 토론/경연, 210은 기타
         "hostIdx": 20000, //주최기간, 10000은 대기업, 20000은 중견기업, 30000은 강소기업, 40000은 스타트업, 50000은 공사/공기업/공공기관, 60000은 외국계기업, 70000은 중앙정부/기관, 75000은 지방자치단체, 80000은 협회/재단, 85000은 비영리단체/학회, 90000은 동아리, 95000은 기타
         "posterDetail": "● 응모 자격\n- 국내 거주 대학(원)생 또는 일반인\n※ 팀 지원 시 3인 이내 구성\n\n ● 응모 분야\n- A.I를 활용한 안전/안심 서비스\n- 사회문제 해결을 위한 신사업 아이디어\n- 스마트시티 관련 서비스(안전/안심)\n\n ● 응모 일정\n- 접수 기간: 2018년 11월 19일(월)~ 2019년 1월 14일(월) 오후 5시까지\n11.19~01.14\n- 예선 발표 : 2019년 1월 18일(금) 온라인 홈페이지 공지 및 개별연락\n01.18\n- 창의교육 : 2019년 1월 23일(수) 예선 합격자 限\n- 멘토링 프로그램 : 2019년 1월 23일(수) ~ 2월 13일(수)\n- 결선 PT 심사 및 시상식 : 2019년 2월 13일(수) 에스원 본사(서울 중구 소재)\n02.13\n\n ● 제출 방법\n- 제출 형식 : 자유 형식, 용량 30MB 이하\n- 제출 파일 : \n① PPT 1부(가로 방향, 10매 내외)\n② PDF 변환 파일 1부 \n③ 워드(DOC) 요약본 1부 (세로 방향, 1매)\n- 필수 포함 내용 : 제안배경, 제안내용, 기대효과\n※ 모든 파일은 zip 파일로 압축하여 제출\n※ 2개 작품 이상 접수 시 1개 작품씩 개별 접수\n※ 파일 내, 개인정보(이름 및 소속 등) 기재 금지\n\n ● 접수방법\n- 공모전 홈페이지(www.s1-idea.co.kr)를 통한 온라인 제출\n※ 오프라인 접수는 받지 않습니다.\n\n ● 유의 사항\n 개인 및 팀 별 출품 작품 수의 제한은 없습니다.\n 타 주제 간 또는 동일주제 내 여러 작품 응모는 가능하나 중복 수상은 불가합니다.\n 동일 작품이 접수될 경우 가장 먼저 접수된 작품만 인정됩니다.\n 응모된 작품에 대한 저작권은 응모자에게 있습니다.\n 해당 공모전의 수상작에 선정될 경우 주최측은 공모전의 취지, 목적을 달성하기 위한 \n 필요한 한도 내에서 해당 수상작을 이용(재편집, 가공 포함)할 수 있습니다.\n 또한, 주최측은 공모전 수상작에 대한 저작재산권의 전부 또는 일부를 우선적으로 양수하거나 이용허락을 받을 수 있으며 범위 및 대가에 대해서는 별도로 협의하여 정할 수 있습니다.  (단, 단순 이용허락만으로 주최측의 완전한 이용을 보장할 수 없는 경우 해당 수상작의 저작재산권은 주최측에 귀속됩니다.단, 이에 대한 대가는 별도 협의로 정합니다.)\n 마감 시간 이후에는 접수가 불가하오니, 반드시 기한 엄수해주시기 바랍니다.\n 타 공모전 수상작·표절작·모방작은 심사에서 제외되며, 입상 후 판명 시에도 입상이 취소됩니다.\n 시상금은 세금 공제 후 지급됩니다.\n●문의 사항\n- 공모전 사무국 02-334-7005 (평일 09:00–18:00 운영)", //포스터 상세보기
         "posterInterest": [ //0은 기획/아이디어, 1은 금융/경제, 2는 디자인, 3은 문학/글쓰기, 4는 문화/예술, 5는 브랜딩/마케팅, 6은 봉사/사회활동, 7은 사진/영상, 8은 창업/스타트업, 9는 체육/건강, 10은 학술/교양, 11은 IT/기술
             0,
             8,
             11
         ],
         "dday" : 7,
         "adminAccept" : 1, //관리자 승인여부
         "keyword" : "#IT/SW #스타트업",
         "favoriteNum : 0,
         "likeNum : 22,
         "isOnlyUniv : 0 //0이면 지역별 타겟팅, 1이면 대학교 직접입력
         
         */
        let mockPosterData = PosterData(posters: Array(repeating: mockPoster, count: 300), userCnt: 300)
        completionHandler(.success(mockPosterData))
    }
    
    func requestPosterStore(of posterIdx: Int, type likedCategory: likedOrDisLiked, completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
    }
    
    func requestPosterDetail(posterIdx: Int, completionHandler: @escaping (DataResponse<DataClass>) -> Void) {
        
    }
    
    func requestPosterFavorite(index: Int, method: HTTPMethod, completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
    }
    
    func requestAllPosterAfterSwipe(category: Int, sortType: Int, completionHandler: @escaping (DataResponse<[PosterDataAfterSwpie]>) -> Void) {
        
    }
    
    
}
