<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegaciÃ³n del form por tabs para que tenga un orden lÃ³gico.
 --->

<!--- Empresas de la CorporaciÃ³n --->
<cfquery name="rsEmpresas" datasource="#Session.DSN#">
	select  Ecodigo, Edescripcion 
	from Empresas
	where cliente_empresarial =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select a.Ecodigo, a.Ocodigo, a.Odescripcion 
	from Oficinas a
	where a.Ecodigo in (  
		select Ecodigo
		from Empresas
		where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#"> 
	)
	and not exists (
		select 1
		from CGAreaResponsabilidadO x
		where x.CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CGARid#">
		  and x.Ecodigo = a.Ecodigo
		  and x.Ocodigo = a.Ocodigo
	)
	order by a.Ecodigo, a.Ocodigo 
</cfquery>
<!--- '<img border=''0'' onClick=''javascript: delOficina("' || <cf_dbfunction name="to_char" args="a.CGAROid"> || '");'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' onmouseover=''javascript: this.style.cursor="pointer"; ''>' as borrar --->

<cf_dbfunction name="to_char" args="a.CGAROid" returnvariable="CGARDid_char">
<cf_dbfunction name="concat" returnvariable="LvarClick" args="<img border=''0'' src=''/cfmx/sif/imagenes/Borrar01_S.gif'' onClick=''javascript:delOficina('+#CGARDid_char#+')'' onmouseover=this.style.cursor=''pointer''> " delimiters="+">



<script language="javascript" type="text/javascript">
	function CambiarOficina(){
		var oCombo   = document.form3.Ocodigo;
		var EcodigoI = document.form3.Empresa.value;
		var cont = 0;
		oCombo.length=0;
		<cfoutput query="rsOficinas">
		if ('#Trim(rsOficinas.Ecodigo)#' == EcodigoI ){
			oCombo.length=cont+1;
			oCombo.options[cont].value='#Trim(rsOficinas.Ocodigo)#';
			oCombo.options[cont].text='#Trim(rsOficinas.Odescripcion)#';
			<cfif  isdefined("rsLinea") and rsLinea.Ocodigo eq rsOficinas.Ocodigo >
				oCombo.options[cont].selected = true;
			</cfif>
		cont++;
		};
		</cfoutput>
	}
	
	function delOficina(cod) {
		if (confirm('Esta seguro de que desea eliminar la oficina?')) {
			document.form3.CGAROid.value = cod;
			document.form3.BajaO.value = "1";
			document.form3.submit();
		}
	}
</script>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
			Agregar Oficina al &Aacute;rea de Responsabilidad
		</td>
	  </tr>
	</table>
  <form id="form3" name="form3" method="post" action="AreaResponsabilidad-sqlOficinas.cfm" style="margin: 0;">
  	<cfinclude template="AreaResponsabilidad-hiddens.cfm">
	<input type="hidden" name="CGAROid" value="" tabindex="-1">
	<input type="hidden" name="BajaO" value="0" tabindex="-1">
    <table width="80%" border="0" cellspacing="0" cellpadding="2" align="center">
	  <tr>
	    <td width="45%" style="background-color:##CCCCCC"><strong>Empresa</strong></td>
	    <td width="45%" style="background-color:##CCCCCC"><strong>Oficina</strong></td>
		<td width="10%" style="background-color:##CCCCCC">&nbsp;</td>
	  </tr>
	  <tr>
	    <td>
			  <select name="Empresa" id="Empresa" onChange="javascript: CambiarOficina(); " tabindex="3">
				<cfloop query="rsEmpresas">
					<option value="#rsEmpresas.Ecodigo#" <cfif isdefined("form.Empresa") and form.Empresa EQ rsEmpresas.Ecodigo> selected</cfif>>#rsEmpresas.Edescripcion#</option>
				</cfloop>
			  </select>
	    </td>
	    <td>
			  <select name="Ocodigo" tabindex="3">
				<cfloop query="rsOficinas"> 
					<option value="#rsOficinas.Ocodigo#" <cfif isdefined("form.Ocodigo") and form.Ocodigo EQ rsOficinas.Ocodigo> selected</cfif>>#rsOficinas.Odescripcion#</option>
				</cfloop>
			  </select>
	    </td>
		<td align="right">
			<input type="submit" name="Alta" value="Agregar" tabindex="3">
		</td>
	  </tr>
    </table>
  </form>
  
    <table width="80%" border="0" cellspacing="0" cellpadding="2" align="center">
	  <tr>
		<td>
			<div id="divOficinas" style="overflow:auto; height: 150; margin:0;" >
				<cfinvoke
				 component="sif.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaDed">
					<cfinvokeargument name="tabla" value="CGAreaResponsabilidadO a
															inner join Empresas b
																on b.Ecodigo = a.Ecodigo
															inner join Oficinas c
																on c.Ecodigo = a.Ecodigo
																and c.Ocodigo = a.Ocodigo"/>
					<cfinvokeargument name="columnas" value="a.CGAROid, a.CGARid, a.Ecodigo, a.Ocodigo, b.Edescripcion, c.Odescripcion, '#LvarClick#' as borrar"/>
					<cfinvokeargument name="filtro" value="a.CGARid = #Form.CGARid# order by b.Edescripcion, c.Odescripcion"/>
					<cfinvokeargument name="desplegar" value="Edescripcion, Odescripcion, borrar"/>
					<cfinvokeargument name="etiquetas" value="Empresa, Oficina, &nbsp;"/>
					<cfinvokeargument name="formatos" value="S,S,S"/>
					<cfinvokeargument name="align" value="left,left,right"/>
					<cfinvokeargument name="ajustar" value="S"/>
					<cfinvokeargument name="formName" value="formListaOficinas"/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="PageIndex" value="3"/>
					<cfinvokeargument name="keys" value="CGAROid"/>
					<cfinvokeargument name="maxRows" value="0"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>
			</div>
		</td>
	  </tr>
    </table>
  
</cfoutput>

<cf_qforms form="form3" objForm="objform3">

<script language="javascript" type="text/javascript">
	objform3.Empresa.required = true;
	objform3.Empresa.description = 'Empresa';
	objform3.Ocodigo.required = true;
	objform3.Ocodigo.description = 'Oficina';
	CambiarOficina();
</script>

