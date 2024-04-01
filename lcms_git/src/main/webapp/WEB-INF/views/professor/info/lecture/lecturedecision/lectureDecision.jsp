<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<div class="table-responsive bg-white" data-toggle="lists"
    data-lists-sort-by="js-lists-values-date" data-lists-sort-desc="true"
    data-lists-values='["js-lists-values-lead", "js-lists-values-a", "js-lists-values-b", "js-lists-values-c", "js-lists-values-project", "js-lists-values-d", "js-lists-values-e"]'
    style="overflow-y: scroll; max-height: 500px; margin: 20px;"
    >
    <table class="table mb-0 thead-border-top-0 table-nowrap" style="margin: 20px;">
        <thead>
               <tr>
                <th style="width: 150px;"><a href="javascript:void(0)"
                        class="sort" data-sort="js-lists-values-project">순번</a></th>

                <th><a href="javascript:void(0)" class="sort"
                        data-sort="js-lists-values-c">학기</a></th>
                <th><a href="javascript:void(0)" class="sort"
                        data-sort="js-lists-values-a">학년</a></th>
                <th><a href="javascript:void(0)" class="sort"
                        data-sort="js-lists-values-b">학과</a></th>
                <th><a href="javascript:void(0)" class="sort"
                        data-sort="js-lists-values-d">강의명</a></th>
                <th><a href="javascript:void(0)" class="sort"
                        data-sort="js-lists-values-e">과목명</a></th>

                <th><a href="javascript:void(0)" class="sort"
                        data-sort="js-lists-values-lead">승인여부</a></th>
                        
                <th>수정</th>
            </tr>
        </thead>
        <c:forEach items="${lectureDecisionList }" var="lectureDecision" varStatus="loop">
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
                                    <strong class="js-lists-values-c">${lectureDecision.subject.subSemester}</strong>
                                </p>
                            </div>
                        </div>
                    </td>

                    <td>
                        <div class="d-flex align-items-center">
                            <div class="flex d-flex flex-column">
                                <p class="mb-0">
                                    <strong class="js-lists-values-a">${lectureDecision.subject.subSchyear }</strong>
                                </p>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="flex d-flex flex-column">
                                <p class="mb-0">
                                    <strong class="js-lists-values-b">${lectureDecision.subject.deptName}</strong>
                                </p>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="flex d-flex flex-column">
                                <p class="mb-0">
                                    <strong class="js-lists-values-d">${lectureDecision.lolName}</strong>
                                </p>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="flex d-flex flex-column">
                                <p class="mb-0">
                                    <strong class="js-lists-values-e">${lectureDecision.subject.subName}</strong>
                                </p>
                            </div>
                        </div>
                    </td>

                    <td>
                       <div class="d-flex flex-column">
							<small class="js-lists-values-status text-50 mb-4pt">
								${lectureDecision.status.statusNm } </small>
							${lectureDecision.reject.rejectReason } <span class="indicator-line rounded bg-warning"></span>
						</div>
                    </td>
					<td>
						<div class="d-flex flex-column">
							<small class="js-lists-values-d text-50 mb-4pt"> <c:choose>
									<c:when test="${lectureDecision.status.statusCode eq 'STA01' }">
									<a href="#" onclick="detailBtn('${lectureDecision.lolAppno }')">상세보기</a>
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
<div id="editArea"></div>

<script src="<c:url value='/resources/js/paging.js'/>"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
var cPath = $('body').data('bodyCpath');
//수정버튼 클릭
function detailBtn(lolAppno) {
    var url = `\${cPath}/professor/info/lecture/lecturedecision/lectureDecisionEditForm/\${lolAppno}`;
   
    $.ajax({
        url: url,
        type: 'GET',
        success: function(response) {
            $('#editArea').html(response);
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
    var lolAppno = $('#lolAppno').val();
    var url = `\${cPath}/professor/info/lecture/lecturedecision/lectureDecisionEditForm`;
    var data = {
    		lolAppno:`\${lolAppno}`
    	    ,appStatus:'STA02'
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
       	 		}).then((result) => {
                    if (result.isConfirmed) {
                        location.href = `\${cPath}/professor/info/lecture/lecturedecision/lectureDecision`;
                    }
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

    // 승인 처리
    var lolAppno = $('#lolAppno').val();
    var url = `\${cPath}/professor/info/lecture/lecturedecision/lectureDecisionEditForm`;
    var data = {
   		lolAppno: `\${lolAppno}`,
   		appStatus: 'STA04',
        appReject: `\${selectedOption}`
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
   	 		}).then((result) => {
                if (result.isConfirmed) {
                    location.href = `\${cPath}/professor/info/lecture/lecturedecision/lectureDecision`;
                }
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
</script>
