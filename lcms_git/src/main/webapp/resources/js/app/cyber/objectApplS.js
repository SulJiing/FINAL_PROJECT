/**
 * 
 */
const cpath = $("body").data("bodyCpath");

function comListData(){
	
	$.ajax({
		url:window.location.pathname + "/comListData"
		, method:"get"
		, dataType : "json"
		, success:function(jsonObj){
			var $complaintList = $("#complaintList");
			$complaintList.empty();
			let dataList = jsonObj.comList;
			let trTags = null;
			
			if(dataList.length > 0){
				$.each(dataList, function(index, c){ //jquery 아닐떄 >> dataList.forEach(function(member)
					
					var appStatus = "";
					
					if(c.appStatus == "STA01"){
						appStatus = "대기중";
						trTags +=`
							<tr>
		                        <td style="width: 5%;">${c.rnum}</td>
		                        <td style="width: 10%">${c.cptType}</td>
		                        <td style="width: 45%;">${c.cptTitle}</td>
		                        <td style="width: 10%">${c.cptDate}</td>
		                        <td style="width: 10%">${appStatus}</td>
		                        <td style="width: 10%"><button type="button" data-cpt-no="${c.cptNo}" class="btn btn-outline-primary btn-rounded deleteApplBtn" onclick="">삭제</button></td>
		                        <td style="width: 10%"><button type="button" data-cpt-no="${c.cptNo}" class="btn btn-outline-primary btn-rounded selectApplBtn" onclick="$('#complaintModal').modal('show');">조회</button></td>
		                    </tr>
							`;
					}else if(c.appStatus == "STA04"){
						appStatus = "반려";
						trTags +=`
							<tr>
		                        <td style="width: 5%;">${c.rnum}</td>
		                        <td style="width: 10%">${c.cptType}</td>
		                        <td style="width: 45%;">${c.cptTitle}</td>
		                        <td style="width: 10%">${c.cptDate}</td>
		                        <td style="width: 10%">${appStatus}</td>
		                        <td style="width: 10%"><button type="button" data-cpt-no="${c.cptNo}" class="btn btn-outline-primary btn-rounded comNoReasonBtn" onclick="$('#comNoReasonModal').modal('show');">반려사유</button></td>
		                        <td style="width: 10%"><button type="button" data-cpt-no="${c.cptNo}" class="btn btn-outline-primary btn-rounded selectApplBtn" onclick="$('#complaintModal').modal('show');">조회</button></td>
		                    </tr>
							`;
					}else if(c.appStatus == "STA06"){
						appStatus = "승인";											
						trTags +=`
							<tr>
		                        <td style="width: 5%;">${c.rnum}</td>
		                        <td style="width: 10%">${c.cptType}</td>
		                        <td style="width: 45%;">${c.cptTitle}</td>
		                        <td style="width: 10%">${c.cptDate}</td>
		                        <td style="width: 10%">${appStatus}</td>
		                        <td style="width: 10%"></td>
		                        <td style="width: 10%"><button type="button" data-cpt-no="${c.cptNo}" class="btn btn-outline-primary btn-rounded selectApplBtn" onclick="$('#complaintModal').modal('show');">조회</button></td>
		                    </tr>
							`;
					}
					
					
				});
			}else{
				trTags = `
					<tr>
						<td colspan="6">정보가 없습니다.</td>
					</tr>
				`;
			}
			
			$complaintList.append(trTags);
			
		}, error : function(jqXHR, txt, status){
			console.log(txt, status, jqXHR);
		}
	});
	
}
comListData();

$(document).on("click", ".selectApplBtn", function(event){
	
	var target = $(event.target);
	var cptNo = target.data("cptNo");
	var smemNo = target.data("smemNo");
	
	$.ajax({
		url:window.location.pathname +"/comDetailData?cptNo=" + cptNo 
		, method:"get"
		, dataType : "json"
		, success:function(jsonObj){
			
			let com = jsonObj.com;
			let trTags = null;
			
			$("#dataInfo").empty();
			$("#dataInfo").append();
			
			trTags +=`
				<tr>
					<th>성명</th><td>${com.memName}</td>
				</tr>
				<tr>
					<th>학번</th><td>${com.smemNo}</td>
				</tr>
				<tr>
					<th>학과</th><td>${com.deptName}</td>
				</tr>
				<tr>
					<th>제목</th><td>${com.cptTitle}</td>
				</tr>
				<tr>
					<th>분류</th><td>${com.cptType}</td>
				</tr>
				<tr>
					<th>내용</th><td>${com.cptComment}</td>
				</tr>
			`;
					
			$("#complaintTable").empty();
			$("#complaintTable").append(trTags);
			
			comTag = "";
			
			if(com.cptType == "출결"){
				var attend = jsonObj.attend;
				comTag += `
					<table style="width: 80%;" border="1">
						<tr style="background-color: pink; height: 30px; font-size: 15px; text-align: center; ">
							<th style="width:50%;">날짜</th><th style="width:50%;">상태</th>
						</tr>
						<tr style="background-color: MistyRose; height: 50px; font-size: 15px; text-align: center; ">
							<td>${attend.atDate}</td><td>${attend.atCode}</td>
						</tr>
					</table>
				`;
				
			}else if(com.cptType == "과제"){
				var task = jsonObj.task;
				comTag += `
					
					<div style="width:100%; display:flex; padding: 15px; border-radius: 15px; background-color: lightgray; margin-bottom: 15px;">
						<div style="width:50%; height: 200px; border-radius: 10px; background-color: white; margin-right: 15px; padding: 15px;">
							<div style="width:100%; display:flex;">
								<div style="width: 80%; margin-right: 15px;">
									<span class="fontStyle">${task.taskTitle}</span>
								</div>
								<div style="width: 20%; text-align: right;">
									<span style="width: 100%;" class="fontStyle">${task.totalScore}점</span>
								</div>
							</div>
							<div style="height: 50px; border-radius: 10xp; padding: 10px; background-color: AliceBlue; margin-bottom: 15px;">
								${task.taskContent}
							</div>
							<div class="fileBox" style="width: 100%; height: 80px; background-color: LightSteelBlue; border-radius: 10px; margin-bottom:5px; padding: 5px;">`;
							
				$.each(task.fileList, function(idx, f){
					
					comTag += `
						<div style="width: 100%; max-width:100%; height: 20px; display:flex; background-color: white; border-radius: 10px; margin-bottom:2px; padding-left:10px;" data-gf-no="${f.gfNo}" data-file-no="${f.fileNo}">
							<div style="width: 60%;">${f.fileNm}</div>
							<div style="width: 30%; text-align: right; padding-right:10px;">${f.fancySize}</div>
							<div style="width: 10%;" data-gf-no="${f.gfNo}" data-file-no="${f.fileNo}" class="fileObj">
								<svg data-v-134867f8="" style="width:10px;" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="file-download" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" class="svg-inline--fa fa-file-download fa-w-12"><path data-v-134867f8="" fill="currentColor" d="M224 136V0H24C10.7 0 0 10.7 0 24v464c0 13.3 10.7 24 24 24h336c13.3 0 24-10.7 24-24V160H248c-13.2 0-24-10.8-24-24zm76.45 211.36l-96.42 95.7c-6.65 6.61-17.39 6.61-24.04 0l-96.42-95.7C73.42 337.29 80.54 320 94.82 320H160v-80c0-8.84 7.16-16 16-16h32c8.84 0 16 7.16 16 16v80h65.18c14.28 0 21.4 17.29 11.27 27.36zM377 105L279.1 7c-4.5-4.5-10.6-7-17-7H256v128h128v-6.1c0-6.3-2.5-12.4-7-16.9z" class=""></path></svg>
							</div>
			 			</div>
					`;
					
				});
						
				var reply = task.taskSubmit.taskReply;	
				if(!reply) reply = "";
								
				comTag +=	`</div>
						</div>
						<div style="width:50%; height: 200px; border-radius: 10px; background-color: PowderBlue; padding: 15px;">
							<div style="width:100%; display:flex;">
								<div style="width: 60%; margin-right: 15px;">
									<span class="fontStyle">과제제출</span>
								</div>
								<div style="width: 20%; text-align: right;">
									<span style="width: 100%;" class="fontStyle">${task.taskSubmit.submitStatus}</span>
								</div>
								<div style="width: 20%; text-align: right;">
									<span style="width: 100%;" class="fontStyle">${task.taskSubmit.taskScore}/${task.totalScore}점</span>
								</div>
							</div>
							<div style="height: 50px; padding: 10px; border-radius: 10px; background-color: AliceBlue; margin-bottom: 15px;">
								${reply}
							</div>
							<div class="fileBox" style="width: 100%; height: 80px; background-color: LightSteelBlue; border-radius: 10px; margin-bottom:5px; padding: 5px;">`;
				$.each(task.taskSubmit.fileList, function(idx, f){
					
					comTag += `
						<div style="width: 100%; max-width:100%; height: 20px; display:flex; background-color: white; border-radius: 10px; margin-bottom:2px; padding-left:10px;" data-gf-no="${f.gfNo}" data-file-no="${f.fileNo}">
							<div style="width: 60%;">${f.fileNm}</div>
							<div style="width: 30%; text-align: right; padding-right:10px;">${f.fancySize}</div>
							<div style="width: 10%;" data-gf-no="${f.gfNo}" data-file-no="${f.fileNo}" class="fileObj">
								<svg data-v-134867f8="" style="width:10px;" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="file-download" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" class="svg-inline--fa fa-file-download fa-w-12"><path data-v-134867f8="" fill="currentColor" d="M224 136V0H24C10.7 0 0 10.7 0 24v464c0 13.3 10.7 24 24 24h336c13.3 0 24-10.7 24-24V160H248c-13.2 0-24-10.8-24-24zm76.45 211.36l-96.42 95.7c-6.65 6.61-17.39 6.61-24.04 0l-96.42-95.7C73.42 337.29 80.54 320 94.82 320H160v-80c0-8.84 7.16-16 16-16h32c8.84 0 16 7.16 16 16v80h65.18c14.28 0 21.4 17.29 11.27 27.36zM377 105L279.1 7c-4.5-4.5-10.6-7-17-7H256v128h128v-6.1c0-6.3-2.5-12.4-7-16.9z" class=""></path></svg>
							</div>
			 			</div>
					`;
					
				});
							
								
				comTag +=	`</div>
						</div>
					</div>

				`;
				
			}else if(com.cptType == "팀플"){
				var tp = jsonObj.tp;
				comTag += `
					
					<div style="width:100%; display:flex; padding: 15px; border-radius: 15px; background-color: lightgray; margin-bottom: 15px;">
						<div style="width:50%; height: 200px; border-radius: 10px; background-color: white; margin-right: 15px; padding: 15px;">
							<div style="width:100%; display:flex;">
								<div style="width: 80%; margin-right: 15px;">
									<span class="fontStyle">${tp.tpName}</span>
								</div>
								<div style="width: 20%; text-align: right;">
									<span style="width: 100%;" class="fontStyle">${tp.tpAssscore}점</span>
								</div>
							</div>
							<div class="fileBox" style="width: 100%; height: 80px; background-color: LightSteelBlue; border-radius: 10px; margin-bottom:5px; padding: 5px;">`;
							
				$.each(tp.fileList, function(idx, f){
					
					comTag += `
						<div style="width: 100%; max-width:100%; height: 20px; display:flex; background-color: white; border-radius: 10px; margin-bottom:2px; padding-left:10px;" data-gf-no="${f.gfNo}" data-file-no="${f.fileNo}">
							<div style="width: 60%;">${f.fileNm}</div>
							<div style="width: 30%; text-align: right; padding-right:10px;">${f.fancySize}</div>
							<div style="width: 10%;" data-gf-no="${f.gfNo}" data-file-no="${f.fileNo}" class="fileObj">
								<svg data-v-134867f8="" style="width:10px;" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="file-download" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" class="svg-inline--fa fa-file-download fa-w-12"><path data-v-134867f8="" fill="currentColor" d="M224 136V0H24C10.7 0 0 10.7 0 24v464c0 13.3 10.7 24 24 24h336c13.3 0 24-10.7 24-24V160H248c-13.2 0-24-10.8-24-24zm76.45 211.36l-96.42 95.7c-6.65 6.61-17.39 6.61-24.04 0l-96.42-95.7C73.42 337.29 80.54 320 94.82 320H160v-80c0-8.84 7.16-16 16-16h32c8.84 0 16 7.16 16 16v80h65.18c14.28 0 21.4 17.29 11.27 27.36zM377 105L279.1 7c-4.5-4.5-10.6-7-17-7H256v128h128v-6.1c0-6.3-2.5-12.4-7-16.9z" class=""></path></svg>
							</div>
			 			</div>
					`;
					
				});
						
				var comment = tp.team.teamComment;	
				if(!comment) comment = "";
								
				comTag +=	`</div>
						</div>
						<div style="width:50%; height: 200px; border-radius: 10px; background-color: PowderBlue; padding: 15px;">
							<div style="width:100%; display:flex;">
								<div style="width: 60%; margin-right: 15px;">
									<span class="fontStyle">과제제출</span>
								</div>
								<div style="width: 20%; text-align: right;">
									<span style="width: 100%;" class="fontStyle">${tp.team.submitStatus}</span>
								</div>
								<div style="width: 20%; text-align: right;">
									<span style="width: 100%;" class="fontStyle">${tp.team.teamproScore}/${tp.tpAssscore}점</span>
								</div>
							</div>
							<div style="height: 50px; padding: 10px; border-radius: 10px; background-color: AliceBlue; margin-bottom: 15px;">
								${comment}
							</div>
							<div class="fileBox" style="width: 100%; height: 80px; background-color: LightSteelBlue; border-radius: 10px; margin-bottom:5px; padding: 5px;">`;
							
				$.each(tp.team.fileList, function(idx, f){
					
					comTag += `
						<div style="width: 100%; max-width:100%; height: 20px; display:flex; background-color: white; border-radius: 10px; margin-bottom:2px; padding-left:10px;" data-gf-no="${f.gfNo}" data-file-no="${f.fileNo}">
							<div style="width: 60%;">${f.fileNm}</div>
							<div style="width: 30%; text-align: right; padding-right:10px;">${f.fancySize}</div>
							<div style="width: 10%;" data-gf-no="${f.gfNo}" data-file-no="${f.fileNo}" class="fileObj">
								<svg data-v-134867f8="" style="width:10px;" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="file-download" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" class="svg-inline--fa fa-file-download fa-w-12"><path data-v-134867f8="" fill="currentColor" d="M224 136V0H24C10.7 0 0 10.7 0 24v464c0 13.3 10.7 24 24 24h336c13.3 0 24-10.7 24-24V160H248c-13.2 0-24-10.8-24-24zm76.45 211.36l-96.42 95.7c-6.65 6.61-17.39 6.61-24.04 0l-96.42-95.7C73.42 337.29 80.54 320 94.82 320H160v-80c0-8.84 7.16-16 16-16h32c8.84 0 16 7.16 16 16v80h65.18c14.28 0 21.4 17.29 11.27 27.36zM377 105L279.1 7c-4.5-4.5-10.6-7-17-7H256v128h128v-6.1c0-6.3-2.5-12.4-7-16.9z" class=""></path></svg>
							</div>
			 			</div>
					`;
					
				});
							
								
				comTag +=	`</div>
						</div>
					</div>

				`;
				
			}
			
			$("#complainDeail").empty();
			$("#complainDeail").append(comTag);
			
			
		}, error : function(jqXHR, txt, status){
			console.log(txt, status, jqXHR);
		}
	});
});
$(document).on("click", ".comNoReasonBtn", function(event){
	
	var target = $(event.target);
	var cptNo = target.data("cptNo");
	
	$.ajax({
		url:window.location.pathname +"/comDetailData?cptNo=" + cptNo 
		, method:"get"
		, dataType : "json"
		, success:function(jsonObj){
			
			let com = jsonObj.com;
			
			$("#comNoReason").empty();
			
			var noReasonTag = `
				<span class="fontStyle">${com.appReject}</span>
			`;
			
			
			$("#comNoReason").append(noReasonTag);
			
			
			
		}, error : function(jqXHR, txt, status){
			console.log(txt, status, jqXHR);
		}
	});
	
});
$(document).on("click", ".deleteApplBtn", function(event){
	var target = $(event.target);
	var cptNo = target.data("cptNo");
	$("#comDeleteForm").find("[name='cptNo']").val(cptNo);
	$("#comDeleteForm").submit();
});

//파일 다운로드
function fn_downloadFile(fileNo){
	let hiddenA = document.createElement("a");
	hiddenA.href = cpath + "/download/single?fileNo=" + fileNo;;
	hiddenA.click();
	hiddenA.remove();
}
$(document).on("click", ".fileObj", function(event){
	var clickedElement = $(event.currentTarget); 
	var gfNo = clickedElement.data("gfNo");
	var fileNo = clickedElement.data("fileNo");
	fn_downloadFile(fileNo);
});


















