<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
학적변동 신청 승인/반려 페이지 (관리자)

<div class="table-responsive" data-toggle="lists"
    data-lists-sort-by="js-lists-values-date" data-lists-sort-desc="true"
    data-lists-values='["js-lists-values-lead", "js-lists-values-a", "js-lists-values-b", "js-lists-values-c", "js-lists-values-project", "js-lists-values-d", "js-lists-values-e"]'
    style="overflow-y: auto; max-height: 400px;"
    >
    
    <table class="table mb-0 thead-border-top-0 table-nowrap">
        <thead>
               <tr>
                <th style="width: 150px;"><a href="javascript:void(0)"
                        class="sort" data-sort="js-lists-values-project">번호</a></th>

                <th><a href="javascript:void(0)" class="sort"
                        data-sort="js-lists-values-c">신청분류명</a></th>
                <th><a href="javascript:void(0)" class="sort"
                        data-sort="js-lists-values-a">학번</a></th>
                <th><a href="javascript:void(0)" class="sort"
                        data-sort="js-lists-values-b">신청날짜</a></th>
                <th><a href="javascript:void(0)" class="sort"
                        data-sort="js-lists-values-d">상세정보</a></th>
            </tr>
        </thead>
        <c:forEach items="${record }" var="record" varStatus="loop">
            <tbody class="list" id="projects">

                <tr>
                    <td>
                        <div class="media flex-nowrap align-items-center"
                            style="white-space: nowrap;">
                            <div class="media-body">
                                <div class="d-flex flex-column">
                                    <small class="js-lists-values-project"><strong>${loop.count }</strong></small>
                                </div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="flex d-flex flex-column">
                                <p class="mb-0">
                                    <strong class="js-lists-values-c">${record.acName}</strong>
                                </p>
                            </div>
                        </div>
                    </td>

                    <td>
                        <div class="d-flex align-items-center">
                            <div class="flex d-flex flex-column">
                                <p class="mb-0">
                                    <strong class="js-lists-values-a">${record.memNo }</strong>
                                </p>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="flex d-flex flex-column">
                                <p class="mb-0">
                                    <strong class="js-lists-values-b">${record.arcDate}</strong>
                                </p>
                            </div>
                        </div>
                    </td>
                   <td>
						<div class="d-flex flex-column">
							<small class="js-lists-values-d text-50 mb-4pt"> <c:choose>
									<c:when test="${record.arcState eq 'STA02' }">
									<a href="#" onclick="detailBtn('${record.arcNo }')">상세보기</a>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn btn-secondary" disabled="">수정불가</button>
									</c:otherwise>
								</c:choose>
							</small>
						</div>
					</td>

                </tr>
            </tbody>
        </c:forEach>
    </table>
</div>
<div id="detailArea"></div>

<script src="<c:url value='/resources/js/paging.js'/>"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
var cPath = $('body').data('bodyCpath');
//수정버튼 클릭
function detailBtn(arcNo) {
    var url = `\${cPath}/manager/stu/academicchange/academicChangeDetail/\${arcNo}`;
   
    $.ajax({
        url: url,
        type: 'GET',
        success: function(response) {
            $('#detailArea').html(response);
        },
        error: function(xhr, status, error) {
            console.error('Error retrieving:', error);
        }
    });
}

//승인버튼
$(document).on("click", "#statusSelect", function(event){
    event.preventDefault(); 
    // 승인 처리
    var arcNo = $('#arcNo').val();
    var acCode = $('#acCode').val();
    var memNo = $('#memNo').val();
    console.log(memNo);
    var url = `\${cPath}/manager/stu/academicchange/academicChangeDetail`;
    var data = {
    		arcNo:`\${arcNo}`
    		,acCode:`\${acCode}`
    	    ,arcState:'STA06'
    	    ,memNo:`\${memNo}`
    	};
    $.ajax({
        url: url,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function(data) {
        	    Swal.fire({
        	      title: '승인 완료',
        	      icon: 'success'
        	    });
        	    $('#editArea').empty();
        },
        error: function(xhr, status, error) {
        	 Swal.fire({
       	      title: '승인 실패',
       	      text: '다시 승인을 진행해주시길 바랍니다.',
       	      icon: 'error'
       	    });
        }
    });
});

$(document).on("click", "#rejectSelect", function(event) {
    event.preventDefault(); 

    var selectedOption = $('#rejectReason').val();

    if (!selectedOption) {
    	Swal.fire({
     	      title: '반려 실패',
     	      text: '반려 사유를 선택해주시길 바랍니다.',
     	      icon: 'error'
     	    });
        return;
    }

    // 반려 처리
    var arcNo = $('#arcNo').val();
    console.log(arcNo);
    var url = `\${cPath}/manager/stu/academicchange/academicChangeDetail`;
    var data = {
   		acCode: `\${acCode}`,
   		arcNo: `\${arcNo}`,
   		arcState: 'STA04',
        arcReject: `\${selectedOption}`
    };
    // AJAX로 POST 요청 보내기
    $.ajax({
        url: url,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function(data) {
        	Swal.fire({
       	      title: '반려 성공',
       	      icon: 'success'
       	    });
        	$('#editArea').empty();
        },
        error: function(xhr, status, error) {
        	Swal.fire({
       	      title: '반려 실패',
       	      text: '다시 반려를 진행해주시길 바랍니다.',
       	      icon: 'error'
       	    });
        }
    });
});

//파일 다운로드
function fn_downloadFile(fileNo){
	let hiddenA = document.createElement("a");
	hiddenA.href = cPath + "/download/single?fileNo=" + fileNo;;
	hiddenA.click();
	hiddenA.remove();
}
function fn_downloadFiles(gfNo){
	let hiddenA = document.createElement("a");
	hiddenA.href = cPath + "/download/multipleGfNo?gfNo=" + gfNo;
	hiddenA.click();
	hiddenA.remove();
}
$(document).on("click", ".fileObj", function(event){
	var clickedElement = $(event.currentTarget); 
	var gfNo = clickedElement.data("gfNo");
	var fileNo = clickedElement.data("fileNo");
	fn_downloadFile(fileNo);
});
</script>
