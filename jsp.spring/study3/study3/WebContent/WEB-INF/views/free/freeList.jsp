
<%@page import="com.study.code.vo.CodeVO"%>
<%@page import="com.study.code.service.CommCodeServiceImpl"%>
<%@page import="com.study.code.service.ICommCodeService"%>
<%@page import="com.study.free.service.FreeBoardServiceImpl"%>
<%@page import="com.study.free.service.IFreeBoardService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.study.free.vo.FreeBoardVO"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%request.setCharacterEncoding("utf-8"); %>
<%@include file="/WEB-INF/inc/header.jsp"%>
</head>
<body>
	<%@ include file="/WEB-INF/inc/top.jsp"%>
	
	후 : ${searchVO }


	<div class="container">
		<div class="page-header">
			<h3>
				자유게시판 - <small>글 목록</small>
			</h3>
		</div>

		<!-- START : 검색 폼  -->
		<div class="panel panel-default">
			<div class="panel-body">
				<!-- 폼턔그 안에서 el사용해서 input들 내용이 유지되게 -->
				<form name="search" action="freeList.wow" method="post"
					class="form-horizontal">
					<input type="hidden" name="curPage" value="${searchVO.curPage }">
					<input type="hidden" name="rowSizePerPage"
						value="${searchVO.rowSizePerPage }">
					<div class="form-group">
						<label for="id_searchType" class="col-sm-2 control-label">검색</label>
						<div class="col-sm-2">
							<select id="id_searchType" name="searchType"
								class="form-control input-sm">
								<option value="T"
									${searchVO.searchType eq "T" ? "selected='selected'" : "" }>제목</option>
								<option value="W"
									${searchVO.searchType eq "W" ? "selected='selected'" : "" }>작성자</option>
								<option value="C"
									${searchVO.searchType eq "C" ? "selected='selected'" : "" }>내용</option>
							</select>
						</div>
						<div class="col-sm-2">
							<input type="text" name="searchWord"
								class="form-control input-sm" value="${searchVO.searchWord }"
								placeholder="검색어">
						</div>
						<label for="id_searchCategory"
							class="col-sm-2 col-sm-offset-2 control-label">분류</label>
						<div class="col-sm-2">
							<select id="id_searchCategory" name="searchCategory"
								class="form-control input-sm">
								<option value="">-- 전체 --</option>
								<c:forEach items="${cateList}" var="code">
									<option value="${code.commCd}"
										${searchVO.searchCategory eq code.commCd ? "selected='selected'" : "" }>${code.commNm}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-2 col-sm-offset-9 text-right">
							<button type="button" id="id_btn_reset"
								class="btn btn-sm btn-default">
								<i class="fa fa-sync"></i> &nbsp;&nbsp;초기화
							</button>
						</div>
						<div class="col-sm-1 text-right">
							<button type="submit" class="btn btn-sm btn-primary ">
								<i class="fa fa-search"></i> &nbsp;&nbsp;검 색
							</button>
						</div>
					</div>
				</form>

			</div>
		</div>
		<!-- END : 검색 폼  -->
		<!-- START : 목록건수 및 새글쓰기 버튼  -->
		<div class="row" style="margin-bottom: 10px;">
			<div class="col-sm-3 form-inline">
				전체 1000건 조회 <select id="id_rowSizePerPage" name="rowSizePerPage"
					class="form-control input-sm">
					<c:forEach var="i" begin="10" end="50" step="10">
						<option value="${i }"
							${i eq searchVO.rowSizePerPage ? "selected='selected'" : "" }>${i }</option>
					</c:forEach>
				</select>
			</div>
		</div>
		<!-- END : 목록건수 및 새글쓰기 버튼  -->




		<div class="row">
			<div class="col-sm-2 col-sm-offset-10 text-right"
				style="margin-bottom: 5px;">
				<a href="freeForm.wow" class="btn btn-primary btn-sm"> <span
					class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
					&nbsp;새글쓰기
				</a>
			</div>
		</div>
		<table class="table table-striped table-bordered table-hover">
			<colgroup>
				<col width="10%" />
				<col width="15%" />
				<col />
				<col width="10%" />
				<col width="15%" />
				<col width="10%" />
			</colgroup>
			<thead>
				<tr>
					<th>글번호</th>
					<th>분류</th>
					<th>제목</th>
					<th>작성자</th>
					<th>등록일</th>
					<th>조회수</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${freeBoardList }" var="freeBoardList">
					<tr class="text-center">
						<td>${freeBoardList.boNo }</td>
						<td>${freeBoardList.boCategoryNm }</td>
						<td class="text-left"><a
							href="freeView.wow?boNo=${freeBoardList.boNo }">
								${freeBoardList.boTitle } </a></td>
						<td>${freeBoardList.boWriter }</td>
						<td>${freeBoardList.boRegDate }</td>
						<td>${freeBoardList.boHit }</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<!-- START : 페이지네이션  -->
		<nav class="text-center">
			<ul class="pagination">

				<!-- 첫 페이지  -->
				<li><a href="freeList.wow?curPage=1" data-page="1"><span
						aria-hidden="true">&laquo;</span></a></li>

				<!-- 이전 페이지 -->
				<c:if test="${searchVO.firstPage!=1 }">
					<li><a href="freeList.wow?curPage=${searchVO.curPage-1 }"
						data-page="${searchVO.curPage-1 }"><span aria-hidden="true">&lt;</span></a></li>
				</c:if>

				<!-- 페이지 넘버링  -->
				<c:forEach var="i" begin="${searchVO.firstPage }"
					end="${searchVO.lastPage }">
					<c:if test="${searchVO.curPage == i }">
						<li class="active"><a href="#">${searchVO.curPage }</a></li>
					</c:if>

					<c:if test="${searchVO.curPage != i }">
						<li><a href="freeList.wow?curPage=${i }" data-page="${i }">${i }</a></li>
					</c:if>
				</c:forEach>
				<!-- <li><a href="freeList.wow?curPage=7" data-page="7">7</a></li>
				<li><a href="freeList.wow?curPage=8" data-page="8">8</a></li>
				<li><a href="freeList.wow?curPage=10" data-page="10">10</a></li> -->

				<!-- 다음  페이지  -->
				<c:if test="${searchVO.lastPage != searchVO.totalPageCount }">
					<li><a href="freeList.wow?curPage=${searchVO.lastPage+1 }"
						data-page="${searchVO.lastPage+1 }"><span aria-hidden="true">&gt;</span></a></li>
				</c:if>

				<!-- 마지막 페이지 -->
				<li><a href="freeList.wow?curPage=${searchVO.totalPageCount }"
					data-page="${searchVO.totalPageCount }"><span
						aria-hidden="true">&raquo;</span></a></li>
			</ul>
		</nav>
		<!-- END : 페이지네이션  -->

	</div>
	<!-- container -->
</body>

<script type="text/javascript">
/* 1.   찾기 :selector , 부모찾기(closest,parent) , 자식찾기(find,child,children)

태그이름    ,id         ,class          ,속성
$("a") ,$("#id")    $(".class이름")    $(input[name='something']")
                                      $("a[href='freeList.wow']")
2. 값 읽기 :    <input type="text" value="3">
			$("input").val() 아무것도 안쓰면 현재값
			$("input").val("5") 안에 쓰면 값 변경
속성 값 읽기와 변경 : <a href="memberList.do">	                                            
				$("a").attr("href");						==memberList.do
					$("a").attr("href", "freeList.do");
				$("a").attr("속성명");					
					$("a").attr("속성명", "변경 하고싶은 값");
					
					
$ 객체랑 document객체는 달라요 . 구별하면서 사용합시다.
$(form 태그 ).submit(); // submit버튼 누른거랑 똑같다 .( 실제로 submit 이벤트가 동작한다)
//form태그 밑에있는 input 태그 값을 대상으로
$(form 태그 ).serialize();  				"?curPage=3&rowSizeperPage=5&........"
		  .serializeobject()			{	"curPage" : "3", "rowSizePerPage" : "5"....} */	


		//form태그 안에 있는 input들은 submit하는 순간 파라미터가 한번에 넘어감
		//name이랑 VO의 필드(속성, 멤버변수)랑 같아야 한다.
		
		// 변수 정의
		$form=$("form[name='search']");
		$curPage=$form.find("input[name='curPage']");

		// 각 이벤트 등록
		// 페이지 링크 클릭
		$('ul.pagination li a[data-page]').click(function(e) {
			e.preventDefault(); // 이벤트 전파 방지,  <a>의 기본 클릭이벤트를 막기위함
			// data-page에 있는 값을 input태그 중 이름이 curPage인 것의 값으로 바꾸고 서브밋
			$curPage.val($(this).data('page'));
			$form.submit();	
		}); // ul.pagination li a[data-page]

		
		$form.find("button[type=submit]").click(function(e) {
			e.preventDefault();
			$curPage.val(1);
			$form.submit();
		});
		
		// 목록 갯수 변경
		// id_rowSizePerPage 변경되었을 때
		// 페이지 1, 목록수 = 현재값 으로 변경 후 서브밋
		$('#id_rowSizePerPage').change(function(e) {
			$curPage.val(1);
			$form.find("input[name='rowSizePerPage']").val($(this).val());
			$form.submit();
		}); // '#id_rowSizePerPage'.change

		// 초기화 버튼 클릭
		$('#id_btn_reset').click(function() {
			$curPage.val(1);
			$form.find("input[name='searchWord']").val("");
			$form.find("select[name='searchType'] option:eq(0)").attr("selected", "selected");
			$form.find("select[name='searchCategory'] option:eq(0)").attr("selected", "selected");
			
			
		}); // #id_btn_reset.click 
	
	</script>
</html>






