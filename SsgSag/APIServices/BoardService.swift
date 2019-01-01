//
//  BoardService.swift
//  SsgSag
//
//  Created by CHOMINJI on 2018. 12. 31..
//  Copyright © 2018년 wndzlf. All rights reserved.
//

import Alamofire

struct BoardService: APIManager, Requestable {
    typealias NetworkData = ResponseArray<Board>
    static let shared = BoardService()
    let boardURL = url("/contents?offset=0&limit=200")
    let registerURL = url("/contents")
    let header: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
    func getBoardList(completion: @escaping ([Board]) -> Void) {
        gettable(boardURL, body: nil, header: header) { (res) in
            switch res {
            case .success(let value):
                guard let boardList = value.data else{return}
                completion(boardList)
            case .error(let error):
                print(error)
            }
        }
    }
    
    //게시글 상세 조회 api
    func getBoardDetail(id: Int, completion: @escaping (Board) -> Void) {
        //코드 작성
    }
    
    //글 작성 api
    //이 api는 조금 다른방식의 request를 보냅니다. 한번 도전해봅시다!
    func uploadBoard(title: String, contents: String, image: UIImage, completion: @escaping () -> Void) {
        
        guard let token = UserDefaults.standard.value(forKey: "token") as? String else{return}
        let uploadHeaders:HTTPHeaders = ["Authorization": token]
        
        Alamofire.upload(multipartFormData: { (multipart) in
            multipart.append(title.data(using: .utf8)!, withName: "title")
            multipart.append(contents.data(using: .utf8)!, withName: "contents")
            multipart.append(image.jpegData(compressionQuality: 0.5)!, withName: "photo", fileName: "image.jpeg", mimeType: "image/jpeg")
        }, to: boardURL,
           headers: uploadHeaders) { (result) in
            
            //멀티파트로 성공적으로 인코딩 되었다면 success, 아니라면 failure 입니다.
            switch result {
            case .success(let upload, _, _):
                // 여기부터는 request 함수와 동일합니다.
                upload.responseObject { (res: DataResponse<ResponseArray<Board>>) in
                    switch res.result {
                    case .success:
                        completion()
                    case .failure(let err):
                        print(err)
                    }
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    //게시글 좋아요 api
    func like() {
        //코드 작성
    }
    
    
}

