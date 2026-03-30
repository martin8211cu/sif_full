<iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>
<cfset contenidohtml = "">
<cfset registrosxcontext = 500>
<cfset tempfile = GetTempDirectory()>
<cfset session.tempfile_xls = #tempfile# & "/tmp_" & #session.Ecodigo# & "_" & #session.usuario# & ".xls">
<cffile action="write" 
	file="#session.tempfile_xls#" output="<!--- Generado #dateformat(now(),"DD/MM/YYYY")# #timeformat(now(),"HH:MM:SS")# --->" 
nameconflict="overwrite">
<cf_dbfunction name="now" returnvariable="hoy">
<!--- Consultas --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo =  #Session.Ecodigo# 
</cfquery>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select
		C.Aplaca as placa,
		C.Adescripcion as descPlaca,
		D.DEidentificacion as cedula,
		<cf_dbfunction name="concat" args="D.DEnombre ,' ',D.DEapellido1 , ' ' ,D.DEapellido2"> as nombre,
		E.CRCCdescripcion as CC,
		F.ACdescripcion AS Categoria,
		G.ACdescripcion as Clase,
		B.AFRfini as FI,
		F.ACcodigodesc AS codCategoria,
		G.ACcodigodesc as CodClasificacion,
		case when (#hoy# >= B.AFRfini and #hoy# <= B.AFRffin) then 'Activo' else 'Inactivo' end as descEstado,
		case when (#hoy# >= B.AFRfini and #hoy# <= B.AFRffin) then 'A' else 'I' end	as idEstado 	

	from AFResponsables B
		inner join Activos C on 
			B.Aid = C.Aid and
			B.Ecodigo = C.Ecodigo
		inner join DatosEmpleado D on 
			B.DEid 	= D.DEid and 
			B.Ecodigo = D.Ecodigo
		inner join CRCentroCustodia E on
			B.Ecodigo = E.Ecodigo and 
			B.CRCCid  = E.CRCCid
		inner join ACategoria F on
			C.Ecodigo = F.Ecodigo and
			C.ACcodigo = F.ACcodigo
		inner join AClasificacion G on
			C.Ecodigo = G.Ecodigo and
			C.ACcodigo = G.ACcodigo and
			C.ACid = G.ACid
		inner join CRTipoDocumento K on
			B.Ecodigo = K.Ecodigo and
			B.CRTDid = K.CRTDid

	where B.Ecodigo =  #Session.Ecodigo# 

	<cfif isdefined("form.APlacaIni") and len(trim(form.APlacaIni))>
		and C.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.APlacaIni#">
	</cfif>
	
	<cfif form.estado eq 'A'>
		and (#hoy# >= B.AFRfini and #hoy# <= B.AFRffin)
	<cfelseif form.estado eq 'I'>
		and #hoy# > B.AFRffin
	</cfif> 		
	
union all

	select
		B.CRDRplaca as placa,
		B.CRDRdescripcion as descPlaca,
		D.DEidentificacion as cedula,
		<cf_dbfunction name="concat" args="D.DEnombre,' ' , D.DEapellido1 ,' ', D.DEapellido2 "> as nombre,
		E.CRCCdescripcion as CC,
		F.ACdescripcion AS Categoria,
		G.ACdescripcion as Clase,
		<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null"> as FI,
		F.ACcodigodesc AS codCategoria,
		G.ACcodigodesc as CodClasificacion,
		'Tránsito' as descEstado,
		'T' as idEstado

	from CRDocumentoResponsabilidad B
		inner join DatosEmpleado D on 
			B.DEid 	= D.DEid and 
			B.Ecodigo = D.Ecodigo
		inner join CRCentroCustodia E on
			B.Ecodigo = E.Ecodigo and 
			B.CRCCid  = E.CRCCid
		inner join ACategoria F on
			B.Ecodigo = F.Ecodigo and
			B.ACcodigo = F.ACcodigo
		inner join AClasificacion G on
			B.Ecodigo = G.Ecodigo and
			B.ACcodigo = G.ACcodigo and
			B.ACid = G.ACid
		inner join CRTipoDocumento K on
			B.Ecodigo = K.Ecodigo and
			B.CRTDid = K.CRTDid

	where B.Ecodigo =  #Session.Ecodigo# 
	
	<cfif isdefined("form.APlacaIni") and len(trim(form.APlacaIni))>
		and B.CRDRplaca = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.APlacaIni#">
	</cfif>
	
	order by placa
</cfquery>

<!--- Filtros --->
<cfset estadoD = " Todos">
<cfset placaInicial  = " No Definida">
<cfif isdefined("form.APlacaIni") and len(trim(form.APlacaIni))>
	<cfset placaInicial  = " " & form.APlacaIni & " (" & form.ADescripcionIni & ")">
</cfif>
<cfif isdefined("form.estado") and len(trim(form.estado))>
	<cfif form.estado eq "A">
		<cfset estadoD = " Activos">
	<cfelseif form.estado eq "I">
		<cfset estadoD = " Inactivos">	
	<cfelseif form.estado eq "T">
		<cfset estadoD = " En Tr&aacute;nsito">		
	</cfif>
</cfif>
<!--- Botones --->
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
<table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
	<cfoutput>
	<tr> 
		<td align="right" nowrap>
			<a href="javascript:regresar();" tabindex="-1">
				<img src="/cfmx/sif/imagenes/back.gif"
				alt="Regresar"
				name="regresar"
				border="0" align="absmiddle">
			</a>				
			<a  href="javascript:imprimir();" tabindex="-1">
				<img src="/cfmx/sif/imagenes/impresora.gif"
				alt="Imprimir"
				name="imprimir"
				border="0" align="absmiddle">
			</a>
			<a  id="EXCEL" href="javascript:SALVAEXCEL();" tabindex="-1">
				<img src="/cfmx/sif/imagenes/Cfinclude.gif"
				alt="Salvar a Excel"
				name="SALVAEXCEL"
				border="0" align="absmiddle">
			</a>								
		</td>
	</tr>
	<tr><td><hr></td></tr>
	</cfoutput>
</table>

<cfsavecontent variable="micontenido" >
	<!--- Estilos --->
	<style>
		H1.Corte_Pagina {
			PAGE-BREAK-AFTER: always
		}
	</style>
	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
</cfsavecontent>
<cfset fnGraba(micontenido,false)>

<!--- Llena el Encabezado --->
<cfset MaxLineasReporte = 60>
<cfsavecontent variable="encabezado">
	<cfoutput>
		<tr><td align="center" colspan="9"><cfinclude template="RetUsuario.cfm"></td></tr>	
		<tr><td align="center" colspan="9"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
		<tr><td align="center" colspan="9"><font size="2"><strong>Documentos por Placa</strong></font></td></tr>
		<tr><td align="center" colspan="9"><strong>Placa: #placaInicial#</strong></td></tr>				
		<tr><td align="center" colspan="9"><strong>Estado: #estadoD#</strong></td></tr>	
		<tr><td align="center" colspan="9"><hr></td></tr>
		<tr>
			<td align="left" bgcolor="##CCCCCC"><strong>Placa</strong></td>
			<td align="left" bgcolor="##CCCCCC"><strong>Descripci&oacute;n</strong></td>
			<td align="left" bgcolor="##CCCCCC"><strong>C&eacute;dula</strong></td>
			<td align="left" bgcolor="##CCCCCC"><strong>Nombre</strong></td>
			<td align="left" bgcolor="##CCCCCC"><strong>Centro Custodia</strong></td>
			<td align="left" bgcolor="##CCCCCC"><strong>Categor&iacute;a</strong></td>
			<td align="left" bgcolor="##CCCCCC"><strong>Clase</strong></td>
			<td align="left" bgcolor="##CCCCCC"><strong>Fecha Ingreso</strong></td>
			<td align="left" bgcolor="##CCCCCC"><strong>Estado</strong></td>			
		</tr>
		<tr><td align="center" colspan="9"><hr></td></tr>
	</cfoutput>
</cfsavecontent>

<!--- Llena el Detalle --->

<cfoutput>
<cfif rsReporte.recordcount gt 0>
	<cfset fnGraba(encabezado,false)>	
	<cfset Ciclos = rsReporte.recordcount \ registrosxcontext>
	<cfset Ciclos = Ciclos + 1>
	<cfset contador = 15>
	<cfloop  index="Cont_Reg" from="1" to="#Ciclos#">
		<cfset startrow = (Cont_Reg-1) * registrosxcontext + 1>
		<cfset endrow = (Cont_Reg * registrosxcontext)>
		<cfif endrow gt rsReporte.recordcount >
			<cfset endrow = rsReporte.recordcount>
		</cfif>	
		<cfloop query="rsReporte" startrow="#startrow#" endrow="#endrow#">
			<cfsavecontent variable="micontenido">
			<cfset bEntra = false>
			<cfif #rsReporte.idEstado# eq 'A' and form.estado eq 'A'>
				<cfset bEntra = true>
			<cfelseif #rsReporte.idEstado# eq 'I' and form.estado eq 'I'>
				<cfset bEntra = true>
			<cfelseif #rsReporte.idEstado# eq 'T' and form.estado eq 'T'>
				<cfset bEntra = true>					
			<cfelseif form.estado eq ''>
				<cfset bEntra = true>
			</cfif>
			
			<cfif bEntra>			
				<cfif contador gte MaxLineasReporte>
					<tr><td align="center" colspan="9"><H1 class=Corte_Pagina></H1></td></tr>
					#encabezado#
					<cfset contador = 15>
				</cfif>
				<tr>				
					<td  valign="top" width="10%" align="left"><font size="1">#trim(placa)#</font></td>
					<td  valign="top"  width="35%" align="left"><font size="1">#trim(descPlaca)#</font></td>
					<td  valign="top"  width="7%" align="left"><font size="1">#trim(cedula)#</font></td>
					<td  valign="top"  width="13%" align="left"><font size="1">#mid(trim(nombre),1,30)#</font></td>
					<td  valign="top"  width="15%" align="left"><font size="1">#mid(trim(CC),1,30)#</font></td>
					<td  valign="top"  width="5%" align="left"><font size="1">#trim(codCategoria)#</font></td>
					<td  valign="top"  width="5%" align="left"><font size="1">#trim(codClasificacion)#</font></td>
					<td  valign="top"  width="8%" align="left"><font size="1">#trim(LSDateFormat("#FI#","dd/mm/yyyy"))#</font></td>
					<td  valign="top"  width="8%" align="left"><font size="1">#trim(descEstado)#</font></td>
				</tr>
				<cfset contador = contador + 1 >
			</cfif>
			</cfsavecontent>
			<cfset fnGraba(micontenido,false)>			
		</cfloop>
	</cfloop>

<cfelse>
	<cfsavecontent variable="micontenido">
		<tr><td align="center" colspan="9">&nbsp;</td></tr>
		<tr><td align="center" colspan="9"><strong> --- La consulta no gener&oacute; ning&uacute;n resultado --- </strong></td></tr>
	</cfsavecontent>
	<cfset fnGraba(micontenido,false)>	
</cfif>
</cfoutput>

<!--- Forma el Reporte  --->
<cfoutput>
<cfsavecontent variable="reporte">
		<tr><td align="center" colspan="9">&nbsp;</td></tr>
		<tr><td colspan="9" nowrap align="center"><strong> --- Fin de la Consulta --- </strong></td></tr>
	</table>
</cfsavecontent>
<cfset fnGraba(reporte,true)>	
</cfoutput>

<!--- *************************************************************************** --->
<cffunction name="fnGraba">
	<cfargument name="contenido" required="yes">
	<cfargument name="fin" required="no" default="no">
	<cfoutput>#contenido#</cfoutput>
	<cfset contenido = replace(contenido,"   "," ","All")>
	<cfset contenido =REReplace(contenido,'([ \t\r\n])+',' ','all')>
	<cfset contenidohtml = contenidohtml & contenido>
	<cfif len(contenidohtml) GT 1048576>
		<cffile action="append" file="#session.tempfile_xls#" output="#contenidohtml#">
		<cfset contenidohtml = "">
	</cfif>

	<cfif fin>
		<cffile action="append" file="#session.tempfile_xls#" output="#contenidohtml#">
		<cfset contenidohtml = "">
	</cfif>
</cffunction>  
<!--- *************************************************************************** --->

<form name="form1" action="HistoricoDocumentos.cfm">
</form>

<!--- Manejo de los Botones --->
<script language="javascript1.2" type="text/javascript">
	function regresar() {
	<cfif isdefined("NOsubmit")>
	 	javascript:history.back(1)
	<cfelse>
		document.form1.submit();
	</cfif>
	}

	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print();
        tablabotones.style.display = '';
	}


	function SALVAEXCEL() {
		var EXCEL = document.getElementById("EXCEL");
		EXCEL.style.visibility='hidden';
		var frame = document.getElementById("FRAMECJNEGRA");
		frame.src = "to_excel.cfm";
	}
</script>