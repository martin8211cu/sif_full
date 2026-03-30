<cfoutput><cf_importLibs></cfoutput>
<cfif session.EcodigoSDC is 0>
  <cflocation url="index.cfm" addtoken="no">
</cfif>
<cfif isdefined("url.seleccionar_EcodigoSDC")>
  <cfset session.menues.Ecodigo = session.Ecodigo>
</cfif>
<cfset session.menues.SScodigo = "">
<cfset session.menues.SMcodigo = "">
<cfset session.menues.SPcodigo = "">
<cfset session.menues.SMNcodigo = "-1">
<cfset session.menues.Sistema1=false>
<cfset session.menues.Modulo1=false>
<cfset t=createObject("component", "sif.Componentes.Translate")>
<cfset tDB=createObject("component", "sif.Componentes.TranslateDB")>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="rsContents" datasource="asp">
	select 
	  rtrim(s.SScodigo) as SScodigo,
	  s.SSdescripcion, 
	  s.SShomeuri,
	  <cf_dbfunction name="length"	args="SSlogo"> SSlogo, s.ts_rversion SStimestamp
	from  SSistemas s
	where s.SSmenu = 1
	  and  (
	  		select count(1) 
			from vUsuarioProcesos up
			   inner join SProcesos p
					on up.SScodigo = p.SScodigo
					and up.SMcodigo = p.SMcodigo
					and up.SPcodigo = p.SPcodigo
					and p.SPmenu = 1 
			   inner join SModulos m
			  	 	on up.SScodigo=m.SScodigo
			  	 	and up.SMcodigo=m.SMcodigo 
			  	 	and m.SMmenu = 1
		where up.Usucodigo = #Session.Usucodigo#
		  and up.Ecodigo   = #Session.EcodigoSDC#
		  and up.SScodigo = s.SScodigo
		  ) > 0
	  
	order by s.SSorden, s.SSdescripcion
</cfquery>
<cfquery name="rsSistema" dbtype="query">
	select distinct SScodigo
	from rsContents
</cfquery>

<cfif rsSistema.RecordCount EQ 1>
  <cfset session.menues.Sistema1=true>
  <cfif Len(Trim(rsContents.SShomeuri))>
    <cfset session.menues.SScodigo = trim(rsContents.SScodigo)>
    <cfset session.menues.SMcodigo = "">
    <cfset session.menues.SPcodigo = "">
    <cfset url.s = rsContents.SScodigo>
    <cfinclude template="pagina.cfm">
    <cfabort>
    <cflocation url="pagina.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#">
  <cfelse>
    <cflocation url="modulo.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#">
  </cfif>
</cfif>
<cfif rsContents.RecordCount EQ 1>
  <cfset session.menues.Modulo1=true>
  <cfset session.menues.SScodigo = trim(rsContents.SScodigo)>
  <cfset session.menues.SPcodigo = "">
</cfif>
<cf_templateheader title="#t.Translate('LB_Inicio','Inicio','/rh/generales.xml')#">
	<cfset Request.PNAVEGACION_SHOWN=true>
	<cfinclude template="pNavegacion.cfm">
    <cfset MostrarHablada = true>
    <cfinclude template="usuarioempresa.cfm">
		<cfset numsistemas = 0>
		<cfoutput query="rsContents" group="SScodigo">
			<cfset numsistemas = numsistemas+1>
		</cfoutput>
		<cfif numsistemas EQ 1>
			<cfset ancho_sistema = 650>
			<cfset ancho_modulo = 320>
		<cfelse>
			<cfset ancho_sistema = 482>
			<cfset ancho_modulo = 214>
		</cfif>

	<!----- pintado del contenido---->	
    <cfif rsContents.RecordCount gt 0 >
		<div class="row">
			<cfset i=0>

			<!----- color para el modulo---->
			<cfset LvarColsSizeOffset=''>  
			<cfset LvarColsSize='col-lg-4 col-md-4 col-sm-4 col-xs-12'> 
			<cfswitch expression="#rsContents.recordcount#">
				<cfcase value="1">
					<cfset LvarColsSizeOffset='col-md-offset-3 col-sm-offset-4'>
					<cfset LvarColsSize='col-md-6 col-sm-5'>
				</cfcase>
				<cfcase value="2">
					<cfset LvarColsSizeOffset=' col-md-offset-2 col-sm-offset-1'>
					<cfset LvarColsSize='col-md-4 col-sm-5'>
				</cfcase>
			</cfswitch>
			<cfset LB_IngreseAlMouduloDelSistema =   t.Translate('LB_IngreseAlMouduloDelSistema','Ingrese a los módulos de','/home/menu/empresa.xml')>
			<cfoutput query="rsContents"><!------- loop de pintado de sistemas---->
				<!---- nombre del sistema---->
				<cfset translated_Sistema = tDB.translate(rsContents.SScodigo,rsContents.SSdescripcion,101)>
				<cfset i+=1>
				<cfif i eq 1>
					<div class="row">
				</cfif>

				<!----- color para el modulo---->
				<cfset LvarColor='colorAzul'>
				<!----
				<cfswitch expression="#SScodigo#">
					<cfcase value="RH">
						<cfset LvarColor='colorAzul'>
					</cfcase>
					<cfcase value="SIF">
						<cfset LvarColor='colorVerde'>
					</cfcase>
					<cfcase value="SYS">
						<cfset LvarColor='colorAmarillo'>
					</cfcase>
				</cfswitch>
				----->
 
				<div class="sistemaItem #LvarColsSize# #LvarColsSizeOffset#">
					<a  href="sistema.cfm?s=#rsContents.SScodigo#">
						<div class="sistemaItemContent #LvarColor#">	
							<div class="sistemaTitulo">#translated_Sistema#</div>
					        <div class="sistemaTexto">#LB_IngreseAlMouduloDelSistema# <strong>#translated_Sistema#.</strong></div>
					        <div class="sistemaImagen">
				        		<cfif rsContents.SSlogo GT 1>
									<cfinvoke  component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsurl" arTimeStamp="#rsContents.SStimestamp#"/>
									<img  align="middle" src="../public/logo_sistema.cfm?s=#URLEncodedFormat(rsContents.SScodigo)#&amp;ts=#tsurl#" border="0" alt="" >
								<cfelse>
									<img align="middle" src="../public/imagen.cfm?f=/home/menu/imagenes/sistema_default.jpg" border="0" alt="" >
								</cfif>	
							</div> 
						</div>
					</a>
				</div>

				<cfif i eq 3 or (rsContents.RecordCount gt 3 and rsContents.RecordCount-rsContents.currentrow lt i) or currentrow eq recordcount>
					</div>
					<cfset i=0>
				</cfif>
				<cfset LvarColsSizeOffset=''>
			</cfoutput>
		</div>
    <cfelse>
      <cfoutput>A&uacute;n no ha sido afiliado a ning&uacute;n m&oacute;dulo </cfoutput>
    </cfif>

<cf_templatefooter>