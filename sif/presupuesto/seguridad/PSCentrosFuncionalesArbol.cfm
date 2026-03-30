<!--- 
	Nombre del Archivo:
		ArbolSistemasNew.cfm
	Proceso:
		Arbol de Centros Funcionles.
	Fechas de Verificación:
		Modificado el 10 de Noviembre del 2004.
	Descripcion del Archivo:
		Este Árbol pinta todos los centros funcionales padres, además si llega la llave de un centro funcional en el cfpk, pinta el Nodo
		que correspondiente al Centro Funcional y todos los Nodos padres hasta llegar a la raiz.
	Observaciones:
		Se realiza una busqueda recursiva de los padres del centro funcional contenido en el CFpk (si llega), se espera que los padres 
		sean cuando mucho unos 4, si son muchos (mas de 10) esta solución se volvería ineficiente.
--->
<table border="0" width="100%"  cellspacing="0" cellpadding="0">
<tr>
<td width="1%">&nbsp;</td>
<td>&nbsp;</td>
<td width="1%">&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>
<!--- Aquí Va el Arbol --->
<!--- 0. Funcionalidad Nueva !!!
	Ahora se puede buscar el Centro Funcional, siempres ha sido engorroso encontrar un centro funcional.
--->
<fieldset><legend>Búsqueda de Centros Funcionales</legend>
<!--- <cf_web_portlet_start titulo="Búsqueda de Centros Funcionales"> --->
<cfoutput>
<form action="#CurrentPage#" method="post" name="formBusquedaCFpk">
<table border="0" width="100%"  cellspacing="0" cellpadding="0" class="AreaFiltro">
	  <tr>
		<td nowrap><strong>C&oacute;digo</strong></td>
		<td nowrap><strong>Descripci&oacute;n</strong></td>
		<td nowrap>&nbsp;</td>
	  </tr>
	  <tr>
		<td nowrap><input name="fCFcodigo" type="text"></td>
		<td nowrap><input name="fCFdescripcion" type="text"></td>
		<td nowrap><input name="btnBuscar" type="submit" value="Buscar"></td>
	  </tr>
	 </table>
</form>
</cfoutput>
<cfif 
	(isdefined("form.fCFcodigo") and len(trim(form.fCFcodigo)))
	or
	(isdefined("form.fCFdescripcion") and len(trim(form.fCFdescripcion)))
>
	<cfquery name="rsGetCFpk" datasource="#session.dsn#">
		select CFid, CFcodigo, CFdescripcion 
		from CFuncional
		where Ecodigo = #Session.Ecodigo#
		<cfif (isdefined("form.fCFcodigo") and len(trim(form.fCFcodigo)))>
			and upper(CFcodigo) like '%#Ucase(form.fCFcodigo)#%'
		</cfif>
		<cfif (isdefined("form.fCFdescripcion") and len(trim(form.fCFdescripcion)))>
			and upper(CFdescripcion) like '%#Ucase(form.fCFdescripcion)#%'
		</cfif>
	</cfquery>
	<div style="overflow:auto; height: 181; margin:0;" >
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td nowrap class="titulolistas"><strong>C&oacute;digo</strong></td>
		<td nowrap class="titulolistas"><strong>Descripci&oacute;n</strong></td>
	  </tr>
	  <cfif rsGetCFpk.recordcount>
	  <cfoutput query="rsGetCFpk"><tr onClick="javascript:document.formFoundCFpk.CFpk.value=#CFid#;document.formFoundCFpk.submit();"
	  	class="<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>"
		onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>';"
		style="cursor:pointer;">
		<td nowrap>#CFcodigo#</td>
		<td nowrap>#CFdescripcion#</td>
	  </tr></cfoutput>
	  <cfelse>
	  <tr><td align="center" colspan="2"><strong>-- No se encontr&oacute; ning&uacute;n resultado --</strong></td></tr>
	  </cfif>
	</table>
	</div>
	<form action="#CurrentPage#" method="post" name="formFoundCFpk">
		<input type="hidden" name="CFpk">
	</form>
</cfif>
</fieldset>
<!--- <cf_web_portlet_end> --->
<br>
<fieldset><legend>Arbol de Centros Funcionales</legend>
<div style="overflow:auto; height: 
	<cfif 
	(isdefined("form.fCFcodigo") and len(trim(form.fCFcodigo)))
	or
	(isdefined("form.fCFdescripcion") and len(trim(form.fCFdescripcion)))
	>
	50
	<cfelse>
	250
	</cfif>
	; margin:0;" >
<!--- <cf_web_portlet_start titulo="Arbol de Centros Funcionales"> --->
<!--- 1. Busqueda de Padres de un Centro Funcional que llega como parámetro (Se hizo click en el Arbol sobre un nodo, o se estaba 
		modificando dicho Centro Funcional y viene del sql.). Aquí se realiza una busqueda recursiva de los padres hasta encontrar 
		la raiz.--->
<cfset litem = "0">
<cfset path  = "0">
<cfif isdefined("Form.CFpk")>
	<cfset litem = Form.CFpk>
	<cfset path =  Form.CFpk>
</cfif>
<cfset n=0>
<cfloop condition="litem neq 0 and n lt 50">
	<cfset n=n+1>
	<cfquery datasource="#session.dsn#" name="papa">
		select coalesce(CFidresp,0) as ancestro
		from CFuncional
		where Ecodigo = #Session.Ecodigo#
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#litem#">
	</cfquery>
	<cfset path = path & iif(len(trim(path)),DE(','),DE('')) & papa.ancestro>
    <cfset litem = papa.ancestro>
    <cfif litem eq "">
		<cfset litem = 0>
    </cfif>
</cfloop>

<!--- 2. Agrega el 0 al path para pintar todos los centros funcionales dependientes de la raíz, los que no tienen padre. --->
<cfset path = path & iif(len(trim(path)),DE(','),DE('')) & "0">

<!--- 3. Crea una variable para el manejo del pintado del Nodo correspondiente al Centro Funcional que llegó --->
<cfif IsDefined('form.CFpk')>
	<cfset ARBOL_pos = form.CFpk>
<cfelse>
	<cfset ARBOL_POS = ''>
</cfif>

<!--- 4. Consulta los Centros Funcionales por pintar, consulta todos los centros funcionales dependientes de la raíz, no tienen padre,
	y consulta todos los centros funcionales padre encontrados en el paso 1.--->
<cfquery datasource="#session.dsn#" name="ARBOL">
	select 
		c.CFid as pk, 
		c.CFcodigo as codigo, 
		c.CFdescripcion as descripcion, 
		c.CFnivel as nivel,  
		(
			select count(1) from CFuncional c2
			where c2.CFidresp = c.CFid
			and c2.Ecodigo = c.Ecodigo
		) as  hijos
	from CFuncional c
	where c.Ecodigo = #Session.Ecodigo#
	  and (c.CFidresp is null
	  	<cfif Len(path)>
			or c.CFidresp in (<cfqueryparam cfsqltype="cf_sql_integer" value="#path#" list="yes">)
		</cfif>
	  )
	order by c.CFpath
</cfquery>


<!--- 5. Se crea estilos que se usan para reducir el tamaño del HTML del arbol --->
<style type="text/css">
	.ar1 {background-color:#D4DBF2;cursor:pointer;}
	.ar2 {background-color:#ffffff;cursor:pointer;}
</style>

<!--- 6. Funciones ejecutadas desde el Árbol --->
<script type="text/javascript" language="javascript">
	<!--//
	<!--- Recibe conexion, form, name y desc --->
	function Asignar(id,name,desc) {
		location.href='<cfoutput>#CurrentPage#</cfoutput>?CFpk=' + escape(id);
	}
	<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
	function eovr(row){<!--- event: MouseOver --->
		row.style.backgroundColor='#e4e8f3';
	}
	function eout(row){<!--- event: MouseOut --->
		row.style.backgroundColor='#ffffff';
	}
	function eclk(arbol_pos){<!--- event: Click --->
		location.href="<cfoutput>#CurrentPage#</cfoutput>?CFpk="+arbol_pos;
	}
	//-->
</script>

<!--- 7. Pintado del Árbol --->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	
	<!--- 7.1 Pinta la Raíz del Árbol --->
	<tr valign="middle"
		<cfif Len(ARBOL_POS) is 0>
			class='ar1'
		<cfelse>
			class='ar2'
			onMouseOver="eovr(this)"
			onMouseOut="eout(this)"
			onClick="eclk('')"
		</cfif>
	>
		<td nowrap>
			<table width="1%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td nowrap><img src="/cfmx/sif/imagenes/Web_Users.gif" width="16" height="16" border="0" align="absmiddle"></td>
				<td nowrap>Mostrar Todo</td>
			  </tr>
			</table>
		</td>
	</tr>
	
	<!--- 7.2 Pinta todos los nodos de los Centros Funcionales --->
	<cfoutput query="ARBOL">
		<tr valign="middle"
			<cfif ARBOL.pk is ARBOL_POS> class='ar1'
				onclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')"
			<cfelse>
				class='ar2' onMouseOver="eovr(this)"
				onMouseOut="eout(this)" 
				<cfif ARBOL.hijos>
					onClick="eclk('#ARBOL.pk#')"
				<cfelse>
					onclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')"
				</cfif>
			</cfif>
			ondblclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#JSStringFormat(ARBOL.descripcion)#')"
		>
			<td nowrap>
				#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
				<cfif ARBOL.hijos and ListFind(path,ARBOL.pk)>
					<img src="/cfmx/sif/imagenes/usuario04_T.gif" width="16" height="16" border="0" align="absmiddle">
				<cfelseif ARBOL.hijos>
					<img src="/cfmx/sif/imagenes/usuario04_T.gif" width="16" height="16" border="0" align="absmiddle">
				<cfelse>
					<img src="/cfmx/sif/imagenes/usuario01_T.gif" width="16" height="16" border="0" align="absmiddle">
				</cfif>
				#HTMLEditFormat(Trim(ARBOL.codigo))# - #HTMLEditFormat(Trim(ARBOL.descripcion))#
			</td>
		</tr>
	</cfoutput>
</table>
</div>
</fieldset>
<!--- <cf_web_portlet_end> --->
<!--- Aquí termina el Árbol --->
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
</table>