<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegación del form por tabs para que tenga un orden lógico.
 --->
 
<cfif modo EQ "CAMBIO">
	<cfquery name="rsData" datasource="#Session.DSN#">
		select a.CGARid, rtrim(a.CGARcodigo) as CGARcodigo, a.CGARdescripcion, a.CGARresponsable, a.CGARemail, a.PCEcatid, b.PCEcodigo, b.PCEdescripcion
		from CGAreaResponsabilidad a
			left outer join PCECatalogo b
				on b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and b.PCEcatid = a.PCEcatid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">
	</cfquery>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="AreaResponsabilidad-sql.cfm" style="margin: 0;">
	  <cfinclude template="AreaResponsabilidad-hiddens.cfm">
	  <table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr>
		  <td colspan="5" class="tituloAlterno" align="center" style="text-transform: uppercase; ">
		  	<cfif modo EQ "CAMBIO">
				Modificando
			<cfelse>
				Agregar nueva 
			</cfif>
			&Aacute;rea de Responsabilidad<cfif modo EQ "CAMBIO">: <font color="##000066">#rsData.CGARdescripcion#</font></cfif>
		  </td>
	    </tr>
		<tr>
		  <td nowrap style="background-color:##CCCCCC"><strong>C&oacute;digo</strong></td>
		  <td nowrap style="background-color:##CCCCCC"><strong>Descripci&oacute;n</strong></td>
		  <td nowrap style="background-color:##CCCCCC"><strong>Responsable</strong></td>
		  <td nowrap style="background-color:##CCCCCC"><strong>Direcci&oacute;n E-mail </strong></td>
		  <td nowrap style="background-color:##CCCCCC"><strong>Plan de Cuentas</strong></td>
		</tr>
		<tr>
		  <td><input type="text" name="CGARcodigo" maxlength="5" size="5" tabindex="1" value="<cfif modo EQ "CAMBIO">#rsData.CGARcodigo#</cfif>"></td>
		  <td><input type="text" name="CGARdescripcion" maxlength="80" size="30" tabindex="1" value="<cfif modo EQ "CAMBIO">#rsData.CGARdescripcion#</cfif>"></td>
		  <td><input type="text" name="CGARresponsable" maxlength="80" size="30" tabindex="1" value="<cfif modo EQ "CAMBIO">#rsData.CGARresponsable#</cfif>"></td>
		  <td><input type="text" name="CGARemail" maxlength="100" size="30" tabindex="1" value="<cfif modo EQ "CAMBIO">#rsData.CGARemail#</cfif>"></td>
		  <td>
		  	<cfif modo EQ "CAMBIO">
				<cf_sifcatalogos form="form1" query="#rsData#" tabindex="1">
			<cfelse>
				<cf_sifcatalogos form="form1" tabindex="1">
			</cfif>
		  </td>
		</tr>
		<tr>
		  <td colspan="5" align="center">
		  		<cf_botones modo="#modo#" tabindex="2">
		  </td>
	    </tr>
	  </table>
	</form>
</cfoutput>

<cf_qforms form="form1" objForm="objForm1">

<script language="javascript" type="text/javascript">

	function funcNuevo() {
		<cfset params = "">
		<cfif isdefined("Form.tab") and Len(Trim(Form.tab))>
			<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "tab=" & Form.tab>
		</cfif>
		<cfif isdefined("Form.PageNum_lista1") and Len(Trim(Form.PageNum_lista1))>
			<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista1=" & Form.PageNum_lista1>
		<cfelseif isdefined("Form.PageNum1") and Len(Trim(Form.PageNum1))>
			<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista1=" & Form.PageNum1>
		</cfif>
		<cfif isdefined("Form.fCGARcodigo") and Len(Trim(Form.fCGARcodigo))>
			<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGARcodigo=" & Form.fCGARcodigo>
		</cfif>
		<cfif isdefined("Form.fCGARdescripcion") and Len(Trim(Form.fCGARdescripcion))>
			<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGARdescripcion=" & Form.fCGARdescripcion>
		</cfif>
		<cfif isdefined("Form.fCGARresponsable") and Len(Trim(Form.fCGARresponsable))>
			<cfset params = params & Iif (Len(Trim(params)), DE("&"), DE("?")) & "fCGARresponsable=" & Form.fCGARresponsable>
		</cfif>
		location.href = "AreaResponsabilidad.cfm<cfoutput>#params#</cfoutput>";
		return false;
	}
	
	function funcBaja(){
		if (confirm('Desea eliminar el registro?')  ){
			objForm1.CGARcodigo.required = false;
			objForm1.CGARdescripcion.required = false;
			objForm1.CGARresponsable.required = false;
			objForm1.PCEcodigo.required = false;
			return true;
		}
		return false;
	}
	

	objForm1.CGARcodigo.required = true;
	objForm1.CGARcodigo.description = 'Código';
	objForm1.CGARdescripcion.required = true;
	objForm1.CGARdescripcion.description = 'Descripción';
	objForm1.CGARresponsable.required = true;
	objForm1.CGARresponsable.description = 'Responsable';
	objForm1.PCEcodigo.required = true;
	objForm1.PCEcodigo.description = 'Plan de Cuentas';
	
</script>