<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
${contentTitle}
<div style="width:100%; background-color: #FFFFFF;" >
<div style="margin-left:10%; width:80%;" class="page-separator" ></div>
<div  style="margin-left:10%; width:80%; background-color: #f0f0f0;">
<p style="overflow-x: auto; white-space: pre-wrap;">
<br>
게시판에 작성되는 본문 내용 및 첨부파일 내에 성명, 주민등록번호, 핸드폰 번호, 이메일 등 2개 이상의 개인정보 작성 시 개인정보보호법 제2조제1호에 의거 개인정보에 해당되어 작성 및 등록을 제한하고 관리자에 의해 삭제 처리될 수 있습니다. 게시판 사용에 유의하시기 바랍니다.

※ 개인정보를 위조 또는 도용, 외부에 유출한 자는 관련법에 의거 법적 처벌을 받을 수 있으며, 게시 글에 포함된 개인정보 또한 책임은 게시자에게 있으며 정보 노출을 원하지 않으실 경우에는 수정 및 삭제하시기 바랍니다. (개인정보보호법 제71조에 의거 개인정보를 유출한 자는 5년 이하의 징역 또는 5천만원 이하의 벌금이 부과될 수 있습니다.)
<br>
</p>
</div>
<div class="page-separator"  style="margin-left:10%; width:80%;"></div>
<form id="insert" method="POST">
<div  style="margin-left:10%; width:80%; background-color: #FFFFFF;" >
    <table style="width:100%; border-collapse: collapse; ">
        <tr>
            <td style="border-top: 1px solid #ddd; border-right: 1px solid #ddd; border-bottom: 1px solid #ddd; margin-top:10px; "><label for="validationSample03">제목</label></td>
            <td style="border-top: 1px solid #ddd; border-bottom: 1px solid #ddd; margin-top:10px;"><input type="text" class="form-control"  id="validationSample03"  style="width:80%;"  placeholder="" required="" name="lecDataname"></td>
        </tr>
        <tr>
            <td style=" border-right: 1px solid #ddd; border-bottom: 1px solid #ddd; margin-top:10px; "><label for="validationSample03">작성자</label></td>
            <td style=" border-bottom: 1px solid #ddd; margin-top:10px;"><input type="text" class="form-control bg-white" id="validationSample03" style="width:30%;" required="" readonly="" name="memName" value="${memName }"></td>
        </tr>
        <tr>
            <td style="display: none;"><input type="text"  name="lecCode" value="${lecCode }"></td>
        </tr>
     <tr>
    <td style=" margin-top:10px; border-right: 1px solid #ddd; border-bottom: 1px solid #ddd;"><label for="validationSample03">첨부파일</label></td>
    <td colspan="2" style="border-bottom: 1px solid #ddd;">
      <div class="custom-file" style="display: flex; margin-top:10px;">
		    <input type="file" id="file" class="custom-file-input" style="width: 50%;" name="daFiles">
		    <label for="file" class="custom-file-label" style="width: 50%;">선택된 파일 없음</label>
		    <button type="button" id="plusFiles" class="btn" style="border: none; outline: none;">
		        <svg data-v-134867f8="" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="plus" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" class="svg-inline--fa fa-plus fa-w-14" style="width:11px;">
		            <path data-v-134867f8="" fill="currentColor" d="M416 208H272V64c0-17.67-14.33-32-32-32h-32c-17.67 0-32 14.33-32 32v144H32c-17.67 0-32 14.33-32 32v32c0 17.67 14.33 32 32 32h144v144c0 17.67 14.33 32 32 32h32c17.67 0 32-14.33 32-32V304h144c17.67 0 32-14.33 32-32v-32c0-17.67-14.33-32-32-32z" class=""></path>
		        </svg>
		    </button>
	</div>
        <p style="margin-top:10px;">&nbsp;*&nbsp;&nbsp;최대 파일사이즈 : 100 MB , 파일은 최대 3개까지 첨부할 수 있습니다.</p>
    </td>
</tr>
        <tr>
            <td style=" margin-top:10px; border-right: 1px solid #ddd; border-bottom: 1px solid #ddd;">
            <label class="form-label">내용</label></td>
            <td style=" margin-top:5px; border-bottom: 1px solid #ddd;">
                 <textArea class="form-control" style="width: 100%; height: 300px" name="lecDatacontent"></textArea>
            </td>
        </tr>
    </table>
</div>
</form>
<div style="display: flex; justify-content: flex-end; margin-top:10px; margin-right:10%;">
    <button id="listBtn" class="btn btn-secondary" style="margin-right:5px;" type="button">목록</button>
    <button id="submitBtn" class="btn btn-primary" style="margin-right:5px;" type="submit">등록</button>
    <button id="cancelBtn" class="btn btn-secondary" type="button">취소</button>
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
$('#plusFiles').on('click', function() {
    var fileNow = $(this).parent().nextAll('.custom-file').length;
    if (fileNow < 2) {
        var fileInput = $('<input type="file" id="file" class="custom-file-input" style="width: 50%;">');
        var label = $('<label for="file" class="custom-file-label" style="width: 50%;">선택된 파일 없음</label>');
        var customFileDiv = $('<div class="custom-file" style="display: flex; margin-top:10px;"></div>').append(fileInput).append(label);
        $(this).parent().after(customFileDiv);
    } else {
    	Swal.fire({
 		      title: '최대 갯수를 초과하여 등록할 수 없습니다.',
 		      icon: 'error'
 	 		})
    }
});

$('#listBtn').on('click',function(){
	window.location.href = 'http://localhost/lcms/professor/cyber/lecturedata/lectureDataList';
});

$('#cancelBtn').on('click',function(){
	$('#newFb input[type="text"]').val('');
// 	$('#newFb textarea').val('');
// 	$('#newFb select').prop('selectedIndex', 0);

	var quillContainer = document.querySelector('[data-toggle="quill"]');
	quillContainer.innerHTML = ''; 
	var quill = new Quill(quillContainer);
});

$('#submitlBtn').on('submit',function(){
	$('#newFb input[type="text"]').val('');
// 	$('#newFb textarea').val('');
// 	$('#newFb select').prop('selectedIndex', 0);

	var quillContainer = document.querySelector('[data-toggle="quill"]');
	quillContainer.innerHTML = ''; 
	var quill = new Quill(quillContainer);
});

document.getElementById('submitBtn').addEventListener('click', function(event) {
    event.preventDefault();
    var $form = $('#insert');
    var formData = new FormData($form[0]);
    $.ajax({
        url: "${pageContext.request.contextPath}/professor/cyber/lecturedata/lectureDataInsertForm",
        method: "POST", 
        data: formData,
        processData: false,
        contentType: false,
        dataType: "json",
        success: function(response) { 
     		    Swal.fire({
     	   		      title: '강의자료 등록 완료',
     	   		      icon: 'success'
     	   	 		}).then((result) => {
     	                if (result.isConfirmed) {
     	                    location.href = 'http://localhost/lcms/professor/cyber/${lecCode}/lectureDataList';
     	                }
     	             });
           },
        error: function(xhr, status, error) {
            console.error(error); 
 		    Swal.fire({
	   		      title: '강의자료 등록 실패',
	   		      icon: 'error'
	   	 		});
        }
    });
});
</script>

<script src="<c:url value='/resources/vendor/moment.min.js' />"></script>
<script src="<c:url value='/resources/vendor/daterangepicker.js' />"></script>
<script src="<c:url value='/resources/js/daterangepicker.js' />"></script>
<script src="<c:url value='/resources/vendor/quill.min.js' />"></script>
<script src="<c:url value='/resources/js/quill.js' />"></script>
<script src="<c:url value='/resources/vendor/select2/select2.min.js' />"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>