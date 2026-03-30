<!---<cfdump var="#form#">
<cfdump var="#url#">--->
<cf_web_portlet_start border="true" titulo="Copia de Valores de Conductor" skin="#Session.Preferences.Skin#">
<cfoutput>
	<form name="form1" action="Valor_Conductor_sql.cfm" method="post">
		<cfif isdefined ('url.CGCid') and isdefined ('url.smes') and isdefined ('url.speriodo') and not isdefined ('url.bandera') >
			<input type="hidden" name="CGCid" value="#url.CGCid#">
			<input type="hidden" name="smes" value="#url.smes#">
			<input type="hidden" name="speriodo" value="#url.speriodo#">
			
			<table width="100%" align="center" border="0">
				<tr>
					<td align="right">
					<strong>Periodo:</strong></td>
					<td><cf_periodos></td>		  
				</tr>
				<tr>
					<td align="right">
					<strong>Mes:</strong></td>
					<td><cf_meses></td>		  
				</tr>
				<tr>
					<td align="center" colspan="2"><input name="copiarD" id="copiarD" value="Listo" type="submit" /></td>
				</tr>
			</table>
		
			<cfif isdefined ('url.bandera1') >
				Para el periodo:#url.periodo# y el mes:#url.mes# no existen Datos			
			</cfif>
		</cfif>
			<cfif isdefined ('url.bandera')>
			<input type="hidden" name="CGCid" 		value="#url.CGCid#">
			<input type="hidden" name="smes" 		value="#url.smes#">
			<input type="hidden" name="speriodo" 	value="#url.speriodo#">
			<input type="hidden" name="mes" 		value="#url.mes#">
			<input type="hidden" name="periodo" 	value="#url.periodo#">
			<table width="100%">
			<tr><td align="center">
			<strong>Ya existen en el periodo y mes en el cual quiere insertar los datos,</br> desea sobreescribirlos</strong>			
			</td></tr>
			<tr><td align="center"><input name="sobreD" id="sobreD" value="Sobrescribir" type="submit" /></td></tr>
			</cfif>
		
	</form>
</cfoutput>
<cf_web_portlet_end>


<!---<cfset navegacion = "">

<cf_navegacion name="CGCperiodo" default="2007" navegacion="">
<cfif isdefined ("form.CGCperiodo") and len(trim(form.CGCperiodo))>
	<cfset navegacion = navegacion & "&CGCperiodo=#form.CGCperiodo#">
</cfif>

<cfif isdefined ("form.filter") and len(trim(form.filter))>
	<cfset navegacion = navegacion & "&filter=#form.filter#">
</cfif>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"  returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsQueryLista#"/>	
	<cfinvokeargument name="desplegar" value="CGCperiodo, CGCmes, Catalogo, CGCvalor"/>
	<cfinvokeargument name="etiquetas" value="Periodo, Mes, Catalogo/UEN, Valor"/>
	<cfinvokeargument name="formatos" value="S,S,S,S,S"/>
	<cfinvokeargument name="align" value="left, left, left, right"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="chkcortes" value="S"/>
	<cfinvokeargument name="keycorte" value="CGCdescripcion"/> 
	<cfinvokeargument name="keys" value="CGCperiodo, CGCmes, CGCvalor, CGCid, F_Catalogo, HDCGCMODO"/>
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="irA" value="ValoresxConductor.cfm"/>
	<cfinvokeargument name="formname" value="linea"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<cfinvokeargument name="Cortes" value="CGCdescripcion,Tipo"/>
	<cfinvokeargument name="fontsize" value="10"/>
	<cfinvokeargument name="botones" value="Eliminar"/>
</cfinvoke>

<script language="javascript" type="text/javascript">
	function funcEliminar(){
		document.linea.action="SQLValoresxConductor.cfm";
		document.linea.submit();
	}
</script>--->