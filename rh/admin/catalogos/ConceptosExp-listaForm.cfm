<cfquery name="rsExpediente" datasource="#Session.DSN#">
	select TEdescripcion
	from TipoExpediente
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
</cfquery>

<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select a.ECEid,  {fn concat(a.ECEcodigo,{fn concat('- ',a.ECEdescripcion)})} as Descripcion
	from EConceptosExpediente a
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and not exists(
		select 1
		from ConceptosTipoE b
		where b.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
		and b.ECEid = a.ECEid
	)
	order by ECEcodigo
</cfquery>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EstaSeguroDeQueDeseaEliminarEsteConcepto"
	Default="¿Está seguro de que desea eliminar este concepto?"
	returnvariable="MSG_EstaSeguroDeQueDeseaEliminarEsteConcepto"/>


<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript">
	qFormAPI.setLibraryPath("/cfmx/sif//js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function del_concepto(c) {
		if (confirm('<cfoutput>#MSG_EstaSeguroDeQueDeseaEliminarEsteConcepto#</cfoutput>')) {
			document.form1.ECEid_del.value = c;
			document.form1.accion.value = "2";
			document.form1.submit();
		}
	}
	
</script>
<cfoutput>
	<form name="form1" method="post" action="ConceptosExp-sql.cfm">
	  <input type="hidden" name="TEid" value="#Form.TEid#">
	  <input type="hidden" name="accion" value="1">
	  <input type="hidden" name="ECEid_del" value="">
	  <table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr>
		  <td align="left" style="font-size: 12pt; padding-right: 10px;" nowrap>&nbsp;</td>
		  <td align="right" style="padding-right: 10px;" nowrap>&nbsp;</td>
		  <td nowrap>&nbsp;</td>
		  <td nowrap>&nbsp;</td>
	    </tr>
		<tr>
		  <td width="15%" align="left" style="font-size: 12pt; padding-right: 10px;" nowrap><strong>#rsExpediente.TEdescripcion#</strong></td>
		  <td width="15%" align="right" style="padding-right: 10px;" nowrap><strong><cf_translate key="LB_Concepto" XmlFile="/rh/generales.xml">Concepto</cf_translate>:</strong></td>
		  <td width="40%" nowrap>
			  <select name="ECEid" tabindex="1">
			  	<cfif rsConceptos.recordCount GT 0>
					<cfloop query="rsConceptos">
						<option value="#rsConceptos.ECEid#">#rsConceptos.Descripcion#</option>
					</cfloop>
				<cfelse>

					<option value="">-- <cf_translate key="MSG_NoExistenMasConceptosPorAgregar">No existen más conceptos por agregar</cf_translate> --</option>
				</cfif>
			  </select>
		  </td>
		  <td nowrap>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Agregar"
				Default="Agregar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Agregar"/>

		  	<input name="btnAgregar" type="submit" tabindex="1" id="btnAgregar" value="#BTN_Agregar#" 
				onClick="javascript: this.form.accion.value = '1';">
			</td>
		</tr>
	  </table>
	</form>
</cfoutput>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td>
<!----
<cfinvokeargument name="columnas" value="ece.ECEid, ece.ECEcodigo ||' - '|| ece.ECEdescripcion as Descripcion, ece.ECEfecha, '<a href=''javascript: del_concepto(' || ece.ECEid || ');''><img src=''/cfmx/rh/imagenes/delete.small.png'' border=''0''></a>' as linkDel"/>
---->		

		<cfquery name="rsLista"	 datasource="#session.DSN#">
			select 	ece.ECEid, 
			        {fn concat(ece.ECEcodigo,{fn concat('- ',ece.ECEdescripcion)})} as Descripcion, 
 					ece.ECEfecha, 
				    {fn concat('<a href=javascript:del_concepto(', {fn concat(<cf_dbfunction name="to_char" args="ece.ECEid" >,');><img src=/cfmx/rh/imagenes/delete.small.png border=0></a>')})} as linkDel
			from ConceptosTipoE a, EConceptosExpediente ece
			where a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
		      and a.ECEid = ece.ECEid
		      and ece.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo# ">
		   order by ece.ECEcodigo
		</cfquery>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Concepto"
			Default="Concepto"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_Concepto"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Fecha"
			Default="Fecha"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_Fecha"/>	
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="Descripcion, ECEfecha, linkDel"/>
			<cfinvokeargument name="etiquetas" value="#LB_Concepto#, #LB_Fecha#, &nbsp;"/>
			<cfinvokeargument name="formatos" value="V,D,V"/>
			<cfinvokeargument name="formName" value="lista"/>
			<cfinvokeargument name="align" value="left, left, center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="maxRows" value="0"/>
			<cfinvokeargument name="botones" value="Nuevo"/>
			<cfinvokeargument name="irA" value="Conceptos.cfm"/>
			<cfinvokeargument name="showLink" value="false"/>
		</cfinvoke>

	</td>
  </tr>
	<tr><td>&nbsp;</td></tr>
</table>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Concepto"
	Default="Concepto"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Concepto"/>	

<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
	objForm.ECEid.required = true;
	objForm.ECEid.description = "#MSG_Concepto#";
	</cfoutput>
</script>