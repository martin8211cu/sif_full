	<cfif isdefined("Url.fFACnombre") and not isdefined("Form.fFACnombre")>
		<cfparam name="Form.fFACnombre" default="#Url.fFACnombre#">
	</cfif>
	<cfif isdefined("Url.codApersona")>
		<cfparam name="Form.codApersona" default="#Url.codApersona#">
	</cfif>
	
	<form name="formFacturas_filtro" method="post" action="facturas.cfm" style="margin: 0">
		<input type="hidden" name="codApersona" value="<cfoutput>#form.codApersona#</cfoutput>">
		<table width="100%" border="0" class="areaFiltro" cellpadding="0" cellspacing="0">
		  <tr> 
			<td nowrap align="right">Factura: </td>
			<td nowrap><input name="fFACnombre" type="text" id="fFACnombre" size="80" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.fFACnombre") AND Form.fFACnombre NEQ ""><cfoutput>#Form.fFACnombre#</cfoutput></cfif>"></td>
			<td align="center" nowrap><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar Facturas"></td>
		  </tr>
		</table>
	</form>
	<cfset filtro = "">
	<cfset navegacion = "">
	<cfif isdefined("Form.fFACnombre") AND Form.fFACnombre NEQ "">
		<cfset filtro = "and upper(rtrim(FACnombre)) like upper('%" & #Trim(Form.fFACnombre)# & "%')">
		<cfset navegacion = "fFACnombre=" & Form.fFACnombre>
	</cfif>		

	<cfinvoke 
	 component="educ.componentes.pListas"
	 method="pListaEdu"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="FacturaEdu"/>
		<cfinvokeargument name="columnas" value="
			 #form.codApersona# as codApersona
			 , case FACestado
					when 1 then 'Por Cobrar'
					when 2 then 'Pagada'
					when 3 then 'Anulada'
					else
						'Indefinido'
				end FACestado
			, convert(varchar,FACcodigo) as FACcodigo
			, convert(varchar,FACfecha,103) as FACfecha
			, FACnombre"/>
		<cfinvokeargument name="desplegar" value="FACnombre, FACestado, FACfecha"/>
		<cfinvokeargument name="etiquetas" value="Factura, Estado, Fecha"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value=" Ecodigo=#session.Ecodigo#
				and Apersona=#form.codApersona#
				#filtro#
			order by FACnombre"/>
		<cfinvokeargument name="align" value="left,center,center"/>
		<cfinvokeargument name="ajustar" value="N,N,N"/>
		<cfinvokeargument name="irA" value="facturas.cfm"/>
		<cfinvokeargument name="formName" value="formListaFacturas"/>
		<cfinvokeargument name="botones" value="Nueva, Pendientes"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="navegacion" value="#navegacion#" />
	</cfinvoke>
	
<script language="JavaScript" type="text/javascript">
	function funcNueva(){
		document.formListaFacturas.CODAPERSONA.value = "<cfoutput>#form.codApersona#</cfoutput>";
	}
	function funcPendientes(){
		document.formListaFacturas.CODAPERSONA.value = "<cfoutput>#form.codApersona#</cfoutput>";
		document.formListaFacturas.FACNOMBRE.value = "<cfoutput>#rsAlumno.Anombre#</cfoutput>";
		document.formListaFacturas.action="facturas_pendientes.cfm";		
	}
</script>