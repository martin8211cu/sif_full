<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfif isdefined("url.AnexoId") and not isdefined("form.AnexoId")>
	<cfset form.AnexoId = url.AnexoId>
</cfif>
<cfif isdefined("url.AnexoCelId") and not isdefined("form.AnexoCelId")>
	<cfset form.AnexoCelId = url.AnexoCelId>
</cfif>

<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td align="center"><strong>Filtro por Concepto</strong></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top"> 
		<cf_dbfunction name="to_char" args="a.Ecodigo" 	returnvariable="Ecodigo" >	
		<cf_dbfunction name="to_char" args="a.Cconcepto" 	returnvariable="Cconcepto" >			
		  <cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="
					AnexoCelConcepto a
						inner join ConceptoContableE b on
							a.Ecodigo = b.Ecodigo and
							a.Cconcepto = b.Cconcepto
						inner join Empresas c on
							a.Ecodigo = c.Ecodigo"/>
				<cfinvokeargument name="columnas" value="
					c.Edescripcion as Enombre,a.Ecodigo,a.Cconcepto as Cconcepto,b.Cdescripcion as Cdescripcion,
					'<img border=''0'' onClick=''eliminar('#_Cat# #PreserveSingleQuotes(Ecodigo)# #_Cat#','#_Cat# #PreserveSingleQuotes(Cconcepto)##_Cat#');'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' >' as Eliminar">
				<cfinvokeargument name="desplegar" value="Enombre, Cconcepto, Cdescripcion, Eliminar"/>
				<cfinvokeargument name="etiquetas" value="Empresa, Código, Descripción del Concepto, &nbsp;"/>
				<cfinvokeargument name="formatos" value="S,S,S,U"/>
				<cfinvokeargument name="filtro" value="a.AnexoCelId = #form.AnexoCelId#"/>
				<cfinvokeargument name="align" value="left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="S,S,S,S"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="showlink" value="false"/>
				<cfinvokeargument name="keys" value="Ecodigo,Cconcepto"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="filtrar_por" value="Enombre,Cconcepto,Cdescripcion,&nbsp;"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="irA" value="anexo-conceptos.cfm?AnexoId=#form.AnexoId#&AnexoCelId=#AnexoCelId#"/>
			  </cfinvoke>				
		</td>				
		<td valign="top">
			<cfinclude template="anexo-conceptos-form.cfm">
		</td>
	</tr>
</table>
</cfoutput>

<table width="100%" cellpadding="0" cellspacing="0">
	<form name="form1" method="post">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="button" name="btnCerrar" value="Cerrar" onClick="javascript:window.close()">
			</td>
		</tr>
	</form>
</table>

<cfoutput>
<script language="javascript">
	function eliminar(ecodigo,cconcepto){
		if (confirm('¿Desea eliminar el Concepto?')){
			document.lista.action = "anexo-conceptos-sql.cfm?AnexoId=#form.AnexoId#&AnexoCelId=#form.AnexoCelId#&Ecodigo="+ecodigo+"&Cconcepto="+cconcepto+"&modo=BAJA";
			document.lista.submit();
		}else{
			return false;
		}
	}
	
	function funcFiltrar() {
		document.lista.action = "anexo-conceptos.cfm?AnexoId=#form.AnexoId#&AnexoCelId=#AnexoCelId#";
		document.lista.submit();
		return true;
	}	
</script>
</cfoutput>