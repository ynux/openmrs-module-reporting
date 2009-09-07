<%@ include file="../manage/localHeader.jsp"%>
<openmrs:require privilege="Manage Reports" otherwise="/login.htm" redirect="/module/reporting/reports/manageReports.list" />

<c:url value="/module/reporting/reports/reportEditor.form" var="pageUrl">
	<c:param name="uuid" value="${report.uuid}" />
</c:url>

<script type="text/javascript" charset="utf-8">

	$(document).ready(function() {

		// Redirect to listing page
		$('#cancel-button').click(function(event){
			window.location.href='<c:url value="/module/reporting/report/reportEditor.form"/>';
		});

		<c:forEach items="${designs}" var="design" varStatus="designStatus">
			$('#${design.uuid}DesignEditLink').click(function(event){
				showReportingDialog({
					title: 'Edit Report Design',
					url: '<c:url value="/module/reporting/viewPortlet.htm?id=reportDesignPortlet&url=reportDesignForm&parameters=reportDesignUuid=${design.uuid}"/>',
					successCallback: function() { window.location.reload(true); }
				});
			});
			$('#${design.uuid}DesignRemoveLink').click(function(event){					
				if (confirm('Please confirm you wish to permanantly delete <b>${design.name}</b>')) {
					document.location.href='${pageContext.request.contextPath}/module/reporting/reports/deleteReportDesign.form?uuid=${design.uuid}&returnUrl=${pageUrl}';
				}
			});
		</c:forEach>
		$('#designAddLink').click(function(event){
			showReportingDialog({
				title: 'Add New Report Design',
				url: '<c:url value="/module/reporting/viewPortlet.htm?id=reportDesignPortlet&url=reportDesignForm&parameters=reportDefinitionUuid=${report.uuid}"/>',
				successCallback: function() { window.location.reload(true); }
			});
		});
		
	} );
</script>

<div id="page">
	<div id="container">
		<h1>Report Editor</h1>
		
		<c:choose>
			
			<c:when test="${report.uuid == null}">
				<b class="boxHeader">Create New Report</b>
				<div class="box">
					<openmrs:portlet url="baseMetadata" id="baseMetadata" moduleId="reporting" parameters="type=org.openmrs.module.report.ReportDefinition|size=380|mode=edit|dialog=false|cancelUrl=manageReports.form|successUrl=reportEditor.form?type=org.openmrs.module.report.ReportDefinition&uuid=uuid" />
				</div>
			</c:when>
			
			<c:otherwise>
		
				<table style="font-size:small;">
					<tr>
						<td valign="top">
							<openmrs:portlet url="baseMetadata" id="baseMetadata" moduleId="reporting" parameters="type=${report.class.name}|uuid=${report.uuid}|size=380|label=Basic Details" />
							<br/>
							<openmrs:portlet url="parameter" id="newParameter" moduleId="reporting" parameters="type=${report.class.name}|uuid=${report.uuid}|label=Parameters|parentUrl=${pageUrl}" />
							<br/>
							<openmrs:portlet url="mappedProperty" id="baseCohortDefinition" moduleId="reporting" 
											 parameters="type=${report.class.name}|uuid=${report.uuid}|property=baseCohortDefinition|label=Base Cohort Definition|nullValueLabel=All Patients" />
							<br/>
							<b class="boxHeader">Output Designs</b>
							<div class="box">
								<c:if test="${!empty designs}">
									<table width="100%" style="margin-bottom:5px;">
										<tr>
											<th style="text-align:left; border-bottom:1px solid black;">Name</th>
											<th style="text-align:left; border-bottom:1px solid black;">Type</th>
											<th style="border-bottom:1px solid black;">[X]</th>
										</tr>
										<c:forEach items="${designs}" var="design" varStatus="designStatus">
											<tr>
												<td nowrap><a href="#" id="${design.uuid}DesignEditLink">${design.name}</a></td>
												<td width="100%">${design.rendererType.simpleName}</td>
												<td nowrap align="center"><a href="#" id="${design.uuid}DesignRemoveLink">[X]</a></td>
											</tr>
										</c:forEach>
									</table>
								</c:if>
								<a style="font-weight:bold;" href="#" id="designAddLink">[+] Add</a>
							</div>
						</td>
						<td valign="top" width="100%">
							<b class="boxHeader">Dataset Definitions</b>
							
							<c:forEach items="${report.dataSetDefinitions}" var="dsd" varStatus="dsdStatus">
								<div style="display:none; width:100%" id="dsdView${dsdStatus.index}">
									<table style="font-size:smaller; color:grey; border:1px solid black;">
										<tr><th colspan="7">${dsd.value.parameterizable.name}</th></tr>
										<tr>
											<c:forEach items="${dsd.value.parameterizable.columns}" var="column" varStatus="colStatus">
												<c:if test="${colStatus.count < 7}">
													<th style="border-bottom:1px solid black;">${column.columnKey}</th>
												</c:if>
												<c:if test="${colStatus.count == 7}">
													<th style="border-bottom:1px solid black;">...</th>
												</c:if>
											</c:forEach>
										</tr>
										<tr>
											<c:forEach items="${dsd.value.parameterizable.columns}" var="column" varStatus="colStatus">
												<c:if test="${colStatus.count <= 7}">
													<td align="center">...</td>
												</c:if>
											</c:forEach>
										</tr>
									</table>
								</div>
							</c:forEach>
							
							<div class="box" style="vertical-align:top;">
								<c:forEach items="${report.dataSetDefinitions}" var="dsd" varStatus="dsdStatus">
									<openmrs:portlet url="mappedProperty" id="dsd${dsd.key}" moduleId="reporting" 
													parameters="type=${report.class.name}|uuid=${report.uuid}|property=dataSetDefinitions|currentKey=${dsd.key}|label=${dsd.key}|parentUrl=${pageUrl}|viewId=dsdView${dsdStatus.index}|headerClass=dsdHeader" />
									<br/>
								</c:forEach>
								<openmrs:portlet url="mappedProperty" id="newDsd" moduleId="reporting" 
												 parameters="type=${report.class.name}|uuid=${report.uuid}|property=dataSetDefinitions|mode=add|label=New Dataset Definition" />
							</div>
							
						</td>
					</tr>
				</table>
				
			</c:otherwise>
			
		</c:choose>
	</div>
</div>
	
<%@ include file="/WEB-INF/template/footer.jsp"%>