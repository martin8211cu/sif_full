<!--- Se incluye una lista de concursantes internos y externos --->
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_interno"
Default="Int."
returnvariable="LB_interno">

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Externo"
Default="Ext."
returnvariable="LB_Externo">




<cfquery name="rsLista" datasource="#session.DSN#">
	select a.RHCPid, b.DEidentificacion as identificacion,case a.RHCPtipo when 'I' then '#LB_interno#' else '#LB_Externo#' end as tipo,
			{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(', ',b.DEnombre)})})})} as Nombre,
		   a.DEid, a.RHOid, a.RHCdescalifica, a.RHCrazondeacalifica, a.RHCPtipo, a.RHCPpromedio, a.RHCevaluado
	from RHConcursantes a, DatosEmpleado b
	where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
	and b.DEid = a.DEid
	and b.Ecodigo = a.Ecodigo
	union
	select a.RHCPid, b.RHOidentificacion as identificacion, case a.RHCPtipo when 'I' then '#LB_interno#' else '#LB_Externo#' end as tipo,
			{fn concat(b.RHOapellido1,{fn concat(' ',{fn concat(b.RHOapellido2,{fn concat(', ',b.RHOnombre)})})})} as Nombre,
		   a.DEid, a.RHOid, a.RHCdescalifica, a.RHCrazondeacalifica, a.RHCPtipo, a.RHCPpromedio, a.RHCevaluado
	from RHConcursantes a, DatosOferentes b
	where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
	and b.RHOid = a.RHOid
	and b.Ecodigo = a.Ecodigo
	order by 2, 3
</cfquery>


<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EstaSeguroDeQueDeseaEliminarA"
	Default="Está seguro de que desea eliminar a"
	returnvariable="LB_EstaSeguroDeQueDeseaEliminarA">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DeEsteConcurso"
	Default="de este concurso"
	returnvariable="LB_DeEsteConcurso">

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBX_IDENTIFICACION"
	Default="Identificaci&oacute;n"
	returnvariable="LB_IDENTIFICACION">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBX_NOMBRE"
	Default="Nombre"
	returnvariable="LB_NOMBRE">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LBX_NOTA"
	Default="Nota"
	returnvariable="LB_NOTA">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DESC"
	Default="Desc."
	returnvariable="LB_DESC">

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo"
	Default="Tipo"
	returnvariable="LB_Tipo">

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TotaldeConcursantes"
	Default="Total de Concursantes"
	returnvariable="LB_TotaldeConcursantes">

<script type="text/javascript" language="javascript">
	<!--
	function NuevoConcursante() {
		document.listaConcursantes.RHCPid.value = '';
		document.listaConcursantes.op.value = '0';
		document.listaConcursantes.submit();
	}

	function Descalificar(c) {
		document.listaConcursantes.RHCPid.value = c;
		document.listaConcursantes.op.value = '2';
		document.listaConcursantes.submit();
	}

	function Evaluar(c) {
		document.listaConcursantes.RHCPid.value = c;
		document.listaConcursantes.op.value = '3';
		document.listaConcursantes.submit();
	}

	function Eliminar(c, v) {
		if (confirm("¿<cfoutput>#LB_EstaSeguroDeQueDeseaEliminarA#</cfoutput> " + v + " <cfoutput>#LB_DeEsteConcurso#</cfoutput>?")) {
			document.listaConcursantes.action = 'ConcursosMng-sql.cfm'
			document.listaConcursantes.RHCPid.value = c;
			document.listaConcursantes.op.value = '4';
			document.listaConcursantes.submit();
		}
	}
	 //--->
</script>

<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="2">&nbsp;</td>
	    <td>&nbsp;</td>
	    <td width="2">&nbsp;</td>
      </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td>
			<fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr>
					<td>&nbsp;<strong><cf_translate key="LB_ListaDeConcursantes">LISTA DE CONCURSANTES</cf_translate></strong></td>
					<td align="right" onMouseOver="javascript: this.style.cursor = 'pointer';" style="font-family:'Times New Roman', Times, serif; font-variant:small-caps; font-size:12px; font-weight:bold;" nowrap>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_NuevoConcursante"
							Default="Nuevo Concursante"
							returnvariable="LB_NuevoConcursante">

						<a href="javascript: NuevoConcursante();"><img src="/cfmx/rh/imagenes/file.png" border="0" title="#LB_NuevoConcursante#" align="absmiddle">[<cf_translate key="LB_Nuevo">Nuevo</cf_translate>]</a>
					</td>
				  </tr>
				</table>
			</fieldset>
		</td>
	    <td>&nbsp;</td>
      </tr>
	  <tr>
		<td>&nbsp;</td>
		<td valign="top">
			<fieldset style="background-color:##F3F4F8; border-top: none; border-left: 1px solid ##CCCCCC; border-right: 1px solid ##CCCCCC; border-bottom: 1px solid ##CCCCCC; ">
				<table width="420" border="0" cellspacing="0" cellpadding="2" style="border-bottom: 1px solid black;">
				  <tr style="height: 25;">
					<td class="tituloListas" width="110" nowrap>#LB_IDENTIFICACION#</td>
					<td class="tituloListas" width="165" nowrap>#LB_NOMBRE#</td>
					<td class="tituloListas" width="45" nowrap>#LB_Tipo#</td>
					<td class="tituloListas" width="42" align="center" nowrap>#LB_NOTA#</td>
					<td class="tituloListas" width="36" align="center" nowrap>#LB_DESC#</td>
					<td class="tituloListas" width="22" nowrap>&nbsp;</td>
					<td class="tituloListas" width="22" nowrap>&nbsp;</td>
					<td class="tituloListas" width="22" nowrap>&nbsp;</td>
				  </tr>
				</table>
				<div id="divConcursantes" style="overflow:auto; height: #tamVentanaConcursantes#; margin:0;" >
				  <form name="listaConcursantes" method="post" action="#currentPage#" id="listaConcursantes">
					<cfinclude template="ConcursosMng-hiddens.cfm">
					<input type="hidden" name="op" value="0">
					<table width="420" border="0" cellspacing="0" cellpadding="2">
					  <cfloop query="rsLista">
					  <tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="javascript: this.className='listaParSel';" onMouseOut="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';" style="height: 25;">
						<td width="110" <cfif rsLista.RHCdescalifica EQ 0>onMouseOver="javascript: this.style.cursor = 'pointer';" onClick="javascript: Evaluar('#rsLista.RHCPid#');"</cfif> nowrap>
							#rsLista.identificacion#
						</td>
						<td width="165" <cfif rsLista.RHCdescalifica EQ 0>onMouseOver="javascript: this.style.cursor = 'pointer';" onClick="javascript: Evaluar('#rsLista.RHCPid#');"</cfif> nowrap>
							#rsLista.nombre#
						</td>
						<td width="45" <cfif rsLista.RHCdescalifica EQ 0>onMouseOver="javascript: this.style.cursor = 'pointer';" onClick="javascript: Evaluar('#rsLista.RHCPid#');"</cfif> nowrap>
							#rsLista.tipo#
						</td>
						<td width="42" align="center" <cfif rsLista.RHCdescalifica EQ 0>onMouseOver="javascript: this.style.cursor = 'pointer';" onClick="javascript: Evaluar('#rsLista.RHCPid#');"</cfif> nowrap>
							<cfif rsLista.RHCevaluado EQ 1>
								#LSNumberFormat(rsLista.RHCPpromedio, ',9.00')#
							<cfelse>
								N/E
							</cfif>
						</td>
						<td width="36" align="center" onMouseOver="javascript: this.style.cursor = 'pointer';" onClick="javascript: Descalificar('#rsLista.RHCPid#');" nowrap>
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_DescalificadoModificarJustificacion"
								Default="Descalificado / Modificar Justificación"
								returnvariable="LB_DescalificadoModificarJustificacion">
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_DescalificarConcursante"
								Default="Descalificar Concursante"
								returnvariable="LB_DescalificarConcursante">
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_EliminarConcursante"
								Default="Eliminar Concursante"
								returnvariable="LB_EliminarConcursante">
							<cfif rsLista.RHCdescalifica EQ 1>
								<img src="/cfmx/rh/imagenes/checked.gif" border="0" title="#LB_DescalificadoModificarJustificacion#">
							<cfelse>
								<img src="/cfmx/rh/imagenes/iedit.gif" border="0" title="#LB_DescalificarConcursante#">
							</cfif>
						</td>
						<td width="22" align="center" onMouseOver="javascript: this.style.cursor = 'pointer';" onClick="javascript: Eliminar('#rsLista.RHCPid#', '#JSStringFormat(rsLista.nombre)#');" nowrap>
							<img src="/cfmx/rh/imagenes/Borrar01_S.gif" border="0" title="#LB_EliminarConcursante#">
						</td>
						<!----- lupa para ver el curriculum--->
						<cfif len(trim(rsLista.RHOid))>
							<td width="22" align="center" onMouseOver="javascript: this.style.cursor = 'pointer';" onClick="javascript: vercurriculum(1,#rsLista.RHOid#,'bRHOid');" nowrap>
								<img src="/cfmx/rh/imagenes/findsmall.gif" border="0">
							</td>
						<cfelse>
							<td width="22" align="center" onMouseOver="javascript: this.style.cursor = 'pointer';" onClick="javascript: vercurriculum(1,#rsLista.DEid#,'bDEid');" nowrap>
								<img src="/cfmx/rh/imagenes/findsmall.gif" border="0">
							</td>
						</cfif>
					  </tr>
					  </cfloop>
					  <tr>
					  <!--- <td><input type="submit" name="Correo" value="<cf_translate key="LB_EnviarCorreos" xmlFile="/rh/generales.xml">Enviar Correos</cf_translate>" onclick="doConlis()" /></td> --->
					  </tr>
					</table>
				  </form>
				</div>
			</fieldset>
		</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <!--- se muestra el total de concursantes --->
	    <td><strong>#LB_TotaldeConcursantes#: #rsLista.recordcount#</strong></td>
	    <td>&nbsp;</td>
      </tr>

	</table>
</cfoutput>
<script language="javascript1.1" type="text/javascript">

var popUpWinSN=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp;
}

function doConlis(){
<cfoutput>
	popUpWindow("/cfmx/rh/Reclutamiento/operacion/concursosCorreo_popUp.cfm?RHCconcurso="+#form.RHCconcurso#,500,450,350,200);
</cfoutput>
}

function closePopUp(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}

function  vercurriculum (modo,key,tipo){
	var PARAM  = "/cfmx/rh/Reclutamiento/candidatos/Curriculum.cfm?RHOid="+ key + "&modo=" + modo+"&"+tipo+"=1";
	open(PARAM,'Curriculum','left=100,top=150,scrollbars=yes,resizable=yes,width=900,height=450')
}

</script>