<cfquery datasource="#session.dsn#" name="rsNombre">
	select  PQnombre as paquete
	from ISBpaquete 
	where ltrim(rtrim(PQcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.PQcodigo)#"> 
</cfquery>

<!---valor de la pagina cuando vi enes por la url en pagenum_Lista2 --->
<cfif isdefined("url.pagenum_Lista2")and len(trim(url.pagenum_Lista2))>
	<cfset url.pagina2 = url.pagenum_Lista2> 
</cfif>
<!---definicion por defecto de filtros y pagina de la lista interna --->
<cfparam name="url.pagina2" default="1">					
<cfparam name="url.Filtro_nombre2" default="">
<cfparam name="url.Filtro_descripcion2" default="">
<cfparam name="url.Filtro_Habilitado2" default="">
<cfif len(trim(url.Pagina2)) eq 0>
	<cfset url.Pagina2 = 1>
</cfif>
<cfoutput>
<form name="form1" method="get" action="ISBpaqueteCambio-apply.cfm" style="margin:0">
	<cfinclude template="ISBpaquete-hiddens.cfm">
	<!----id de la lista principal que se envia por el form para no perder el valor--->
	<input type="hidden" name="PQcodigo" value="<cfif isdefined("form.PQcodigo")>#form.PQcodigo#</cfif>">
	<input name="PQnombre" type="hidden" id="PQnombre" value="<cfif isdefined("url.PQnombre")>#url.PQnombre#</cfif>">
	<!---Hiddens para filtros y pagina de la lista interna --->
	<input type="hidden" name="pagina2" value="#url.pagina2#">
	<input type="hidden" name="Filtro_nombre2" value="#url.Filtro_nombre2#">
	<input type="hidden" name="Filtro_descripcion2" value="#url.Filtro_descripcion2#">
	<input type="hidden" name="Filtro_Habilitado2" value="#url.Filtro_Habilitado2#">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<cfif len(rsNombre.paquete)>
	  <tr>
		<td colspan="3" align="center" class="menuhead">
			#rsNombre.paquete#
		</td>
	  </tr>
	</cfif>
	   <tr align="center" >
	   		<td colspan="3" class="subTitulo">Elija el paquete que desea agregar a la lista de paquetes permitidos</td>
	   </tr>
		<tr>
			<td align="right" width="25%" valign="middle">Paquete</td>
			<td valign="middle" width="35%">		
			<cfset idPaquete = "">
			<cf_paquete 
				id = "#idPaquete#"
				sufijo = "2"
				agente = ""
				form = "form1"
				funcion = ""
				filtroPaqInterfaz = "0"
				Ecodigo = "#session.Ecodigo#"
				Conexion = "#session.DSN#"
				showCodigo="false"
			>
			</td>
			<td valign="middle">
				<cf_botones names="Guardar" values="Guardar" tabindex="1">
			</td>
		</tr>
	</table>
</form>

<table  width="100%"border="0" cellpadding="2" cellspacing="0">
	<tr><td>
		
		<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO HABILITADO--->
		<cfquery datasource="#session.dsn#" name="rsHabilitado2">
			select '' as value, '-- todos --' as description, '0' as ord
			union
			select '0' as value, 'Inhabilitado' as description, '1' as ord
			union
			select '1' as value, 'Habilitado' as description, '1' as ord
			order by 3, 2
		</cfquery>
		
		<cfquery name="rsLista" datasource="#session.DSN#">
			select 
				rtrim(ltrim(b.PQcodigo)) || '-' || b.PQnombre as nombre2, 
				b.PQdescripcion as descripcion2,
				case b.Habilitado 
				when 1 then '<img src=''/cfmx/saci/images/w-check.gif'' border=''0''>'
				else ''
				end as Habilitado2,
				'<a href=''javascript: Eliminar("' || rtrim(a.PQcodDesde) || '","' || rtrim(a.PQcodHacia) || '");''><img src=''/cfmx/saci/images/Borrar01_S.gif'' border=''0''></a>' as imag
			
			from ISBpaqueteCambio a
				inner join ISBpaquete b
					on b.PQcodigo = a.PQcodHacia
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			where a.PQcodDesde = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PQcodigo#">
			<cfif isdefined("url.Filtro_nombre2") and len(trim(url.Filtro_nombre2))>
				and (upper(rtrim(ltrim(b.PQcodigo))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#ucase(trim(url.Filtro_nombre2))#%">
					or upper(rtrim(ltrim(b.PQnombre))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(url.Filtro_nombre2))#%">)
			</cfif>
			<cfif isdefined("url.Filtro_descripcion2") and len(trim(url.Filtro_descripcion2))>
				and upper(rtrim(ltrim(b.PQdescripcion))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(url.Filtro_descripcion2))#%">
			</cfif>
			<cfif isdefined("url.Filtro_Habilitado2") and len(trim(url.Filtro_Habilitado2))>
				and b.Habilitado = <cfqueryparam cfsqltype="cf_sql_bit" value="#trim(url.Filtro_Habilitado2)#">
			</cfif>
			order by b.PQcodigo,b.PQnombre,b.PQdescripcion
		</cfquery>
		<form name="lista2" method="get" action="ISBpaquete-edit.cfm" style="margin:0">
			<cfinclude template="ISBpaquete-hiddens.cfm">
			<input type="hidden" name="PQcodigo" value="<cfif isdefined("form.PQcodigo")>#form.PQcodigo#</cfif>">
			<cfinvoke 
				component="sif.Componentes.pListas" 
				method="pListaQuery"
				returnvariable="rsRet"
				query="#rsLista#"
				desplegar="nombre2,descripcion2,Habilitado2,imag"
				etiquetas="Nombre,Descripcion,Habilitado,&nbsp;"
				incluyeForm="false"
				formName="lista2"
				PageIndex="2"
				mostrar_filtro="true"
				form_method="get"
				filtrar_automatico="false"
				filtrarpor="b.PQnombre,b.PQdescripcion,b.Habilitado,imag"
				align="left,left,left,center"				
				formatos="S,S,I,U"
				ajustar="N"
				maxrows="10"
				showLink="false"
				irA="#CurrentPage#"
				navegacion="Filtro_nombre2=#url.Filtro_nombre2#&HFiltro_nombre2=#url.Filtro_nombre2#&Filtro_descripcion2=#url.Filtro_descripcion2#&HFiltro_descripcion2=#url.Filtro_descripcion2#&Filtro_Habilitado2=#url.Filtro_Habilitado2#&HFiltro_Habilitado2=#url.Filtro_Habilitado2#"
				rshabilitado2="#rsHabilitado2#"
				showEmptyListMsg="true"
				EmptyListMsg="No existen paquetes asociados"
			/>
		</form>
		<script language="javascript1.2" type="text/javascript">
			function Eliminar(PQdesde,PQhacia){
				if (confirm("¿Desea eliminar el paquete de la lista de paquetes permitidos?")) {
					<!---pagina y filtros de la lista de detalles del tab actual(tab 3)--->
					<cfset params2 = "&pagina2=#url.pagina2#&Filtro_nombre2=#url.Filtro_nombre2#&Filtro_descripcion2=#url.Filtro_descripcion2#&Filtro_Habilitado2=#url.Filtro_Habilitado2#">
					document.lista2.method = "post";
					document.lista2.action = "ISBpaqueteCambio-apply.cfm?Baja=1&PQcodigo2="+PQhacia+"&#params##params2#";
					document.lista2.submit();
					return false;
				}
			}
		</script>
		<br />
		
		<form name="form2" method="post" style="margin: 0;" action="#CurrentPage#">
			<cfinclude template="ISBpaquete-hiddens.cfm">
			<input type="hidden" name="PQcodigo" value="<cfif isdefined("form.PQcodigo")>#form.PQcodigo#</cfif>">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td>
				<cf_botones names="Lista" values="Lista" tabindex="1">
			</td>
		  </tr>
		</table>
		</form>
	</td></tr>
</table>

</cfoutput>