
<cfif isdefined('url.CCTcodigoE') and not isdefined('form.CCTcodigoE')>
	<cfset form.CCTcodigoE = url.CCTcodigoE>
</cfif>
<cfif isdefined('url.PAGENUM_LISTA') and not isdefined('form.PAGENUM_LISTA')>
	<cfset form.PAGENUM_LISTA = url.PAGENUM_LISTA>
</cfif>
<cfif isdefined('url.DocIntMora') and not isdefined('Form.DocIntMora')>
	<cfset form.DocIntMora = url.DocIntMora>
</cfif>
<cfif isdefined('url.SNnombre1') and not isdefined('Form.SNnombre1')>
	<cfset form.SNnombre1 = url.SNnombre1>
</cfif>
<cfif isdefined('url.SNnombre2') and not isdefined('Form.SNnombre2')>
	<cfset form.SNnombre2 = url.SNnombre2>
</cfif>
<cfif isdefined('url.SNnombre1') and not isdefined('Form.SNnombre1')>
	<cfset form.SNnombre1 = url.SNnombre1>
</cfif>

<cfif isdefined('url.Cid') and not isdefined('Form.Cid')>
	<cfset form.Cid = url.Cid>
</cfif>
<cfif isdefined('url.Tasa') and not isdefined('Form.Tasa')>
	<cfset form.Tasa = url.Tasa>
</cfif>
<cfif isdefined('url.Agregar') and not isdefined('form.Agregar')>
	<cfset form.Agregar = url.Agregar>
</cfif>
<cfif isdefined('url.marcados') and not isdefined('form.marcados')>
	<cfset form.marcados = url.marcados>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<form action="listaDocInteresMoratorioCxC.cfm" name="form1" method="post" >
	
		<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2"><cfinclude template="NeteoRegistroInteresMCxC.cfm"></td>
			</tr>
			<!---<cfif isdefined('Form.Agregar') or isdefined('Form.Filtrar') or isdefined('Form.Pagenum_lista')>
				<tr>
					<td colspan="2"><cfinclude template="listaDocInteresMoratorioCxC.cfm"></td>
				</tr>
			</cfif>--->
		</table>
	<br>
</form>

