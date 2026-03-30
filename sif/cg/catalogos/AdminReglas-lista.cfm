<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
<cfset CurrentPage = CurrentPage> <!---& "?btnElegirGrp=1&cboGrupos=#LvarGrp#">--->
<cfset MaxRows = 25>
<cfset LvarDias = 60>

<!---FILTRO EN CASO DE SER PARA RESTAURACIÓN DE REGLA--->
<cfset LvarPCReglas ="PCReglas">
<cfif isdefined("LvarRestaurar")>
	<cfset LvarPCReglas ="HPCReglas">
</cfif>

<cfif isdefined("form.MaxRows")>
	<cfset MaxRows = form.MaxRows>
</cfif>

<cfif isdefined("url.filtro_OficodigoM") and Len(Trim(url.filtro_OficodigoM)) and not isdefined("form.filtro_OficodigoM")>
	<cfset form.filtro_OficodigoM = url.filtro_OficodigoM>
</cfif>
<cfif isdefined("url.filtro_Cmayor") and Len(Trim(url.filtro_Cmayor)) and not isdefined("form.filtro_Cmayor")>
	<cfset form.filtro_Cmayor = url.filtro_Cmayor>
</cfif>
<cfif isdefined("url.filtro_PCRregla") and Len(Trim(url.filtro_PCRregla)) and not isdefined("form.filtro_PCRregla")>
	<cfset form.filtro_PCRregla = url.filtro_PCRregla>
</cfif>
<cfif isdefined("url.filtro_PCRvalida") and Len(Trim(url.filtro_PCRvalida)) and not isdefined("form.filtro_PCRvalida")>
	<cfset form.filtro_PCRvalida = url.filtro_PCRvalida>
</cfif>
<cfif isdefined("url.filtro_PCRdesde") and Len(Trim(url.filtro_PCRdesde)) and not isdefined("form.filtro_PCRdesde")>
	<cfset form.filtro_PCRdesde = url.filtro_PCRdesde>
</cfif>
<cfif isdefined("url.filtro_PCRhasta") and Len(Trim(url.filtro_PCRhasta)) and not isdefined("form.filtro_PCRhasta")>
	<cfset form.filtro_PCRhasta = url.filtro_PCRhasta>
</cfif>
<cfif isdefined("url.RetTipos") and Len(Trim(url.RetTipos)) and not isdefined("form.RetTipos")>
	<cfset form.RetTipos = url.RetTipos>
</cfif>
<cfif isdefined("url.FecMayores")>
	<cfset form.FecMayores = url.FecMayores>
</cfif>

<!--- Obtiene la cuenta de mayor del grupo --->
<cfset LvarMyr = "">
<cfquery datasource="#session.dsn#" name="rsMayor">
	Select a.Cmayor
	from PCReglaGrupo a
			inner join CtasMayor b
				 on a.Cmayor = b.Cmayor
				and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and a.PCRGid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGrp#">
</cfquery>
<cfset LvarMyr = trim(rsMayor.Cmayor)>
<cfset ctamayor = LvarMyr>
<cfset filtro_Cmayor = LvarMyr>


<cfif not isdefined("form.filtro_Cmayor")>
	<cfset form.filtro_Cmayor = LvarMyr>
</cfif>

<cfset navegacion = "">
<cfif isdefined("Form.filtro_OficodigoM") and Len(Trim(Form.filtro_OficodigoM))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_OficodigoM=" & Form.filtro_OficodigoM>
</cfif>
<!--- En este caso si se puede enviar filtro_Cmayor en blanco --->
<cfif isdefined("Form.filtro_Cmayor")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_Cmayor=" & Form.filtro_Cmayor>
</cfif>
<cfif isdefined("Form.filtro_PCRregla") and Len(Trim(Form.filtro_PCRregla))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRregla=" & Form.filtro_PCRregla>
</cfif>
<cfif isdefined("Form.filtro_PCRvalida") and Len(Trim(Form.filtro_PCRvalida))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRvalida=" & Form.filtro_PCRvalida>
</cfif>
<cfif isdefined("Form.filtro_PCRdesde") and Len(Trim(Form.filtro_PCRdesde))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRdesde=" & Form.filtro_PCRdesde>
</cfif>
<cfif isdefined("Form.filtro_PCRhasta") and Len(Trim(Form.filtro_PCRhasta))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_PCRhasta=" & Form.filtro_PCRhasta>
</cfif>
<cfif isdefined("Form.FecMayores")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "FecMayores=" & Form.FecMayores>
</cfif>
<cfif isdefined("Form.RetTipos")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "RetTipos=" & Form.RetTipos>
</cfif>
	
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "MaxRows=" & MaxRows>

<!--- Obtener Cuenta Mayor por Defecto --->
<cfif not isdefined("Form.filtro_Cmayor")>
	<cfif isdefined("Form.Cmayor")>
		<cfset Form.filtro_Cmayor = Form.Cmayor>
	<cfelse>
		<cfquery name="rsCtasMayor" datasource="#Session.DSN#">
			select min(Cmayor) as Cmayor
			from PCReglas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfset Form.filtro_Cmayor = rsCtasMayor.Cmayor>
	</cfif>
</cfif>

<!--- Lista de Reglas de Nivel 1 --->
<cfquery name="rsReglas" datasource="#session.DSN#">
	select a.PCRid, 
		   a.Ecodigo, 
		   a.Cmayor, 
		   a.PCEMid, 
		   a.OficodigoM, 
		   a.PCRref, 
		   a.PCRdescripcion, 
		   a.PCRregla, 
		   case when a.PCRvalida = 1 then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>' end as PCRvalida, 
		   a.PCRdesde, 
		   a.PCRhasta, 
		   (select coalesce(count(1), 0) 
		   from #LvarPCReglas# x 
		   where x.Ecodigo = a.Ecodigo
		   and x.PCRref = a.PCRid
		   and x.PCRid <> a.PCRid
		   ) as cantNivel2
	from #LvarPCReglas# a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and (a.PCRref is null or a.PCRid = a.PCRref)
	
	<!--- Unicamente se muestran las reglas de las cuentas de mayor definidas en el grupo--->
	and a.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMyr#">
	and a.PCRGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGrp#">

	
	<cfif isdefined("form.filtro_OficodigoM") and Len(Trim(form.filtro_OficodigoM))>
		and upper(a.OficodigoM) like <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.filtro_OficodigoM))#%">	
	</cfif>	
	<cfif isdefined("form.filtro_Cmayor") and Len(Trim(form.filtro_Cmayor))>
		and upper(a.Cmayor) like <cfqueryparam cfsqltype="cf_sql_char" value="%#UCase(Trim(form.filtro_Cmayor))#%">
	</cfif>
	<cfif isdefined("Form.filtro_PCRregla") and Len(trim(form.filtro_PCRregla))>
		and (
			upper(a.PCRregla) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(form.filtro_PCRregla))#%">
			or
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(form.filtro_PCRregla))#"> like {fn concat ( {fn concat( '%', upper(a.PCRregla) )}, '%')}
		)
	</cfif>
	<cfif isdefined("form.filtro_PCRvalida") and Len(Trim(form.filtro_PCRvalida))>
		and a.PCRvalida = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.filtro_PCRvalida#">
	</cfif> 
	
	<cfif isdefined("form.FecMayores")>
		<cfif isdefined("form.filtro_PCRdesde") and Len(Trim(form.filtro_PCRdesde)) and isdefined("form.filtro_PCRhasta") and Len(Trim(form.filtro_PCRhasta))>
			and <cf_dbfunction name="to_date00" args="a.PCRdesde"> = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PCRdesde)#">
			and <cf_dbfunction name="to_date00" args="a.PCRhasta"> = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PCRhasta)#">
		<cfelseif isdefined("form.filtro_PCRdesde") and Len(Trim(form.filtro_PCRdesde))>
			and <cf_dbfunction name="to_date00" args="a.PCRdesde"> >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PCRdesde)#">
		<cfelseif isdefined("form.filtro_PCRhasta") and Len(Trim(form.filtro_PCRhasta))> 
			and <cf_dbfunction name="to_date00" args="a.PCRhasta"> <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PCRhasta)#">
		</cfif>
	<cfelse>
		<cfif isdefined("form.filtro_PCRdesde") and Len(Trim(form.filtro_PCRdesde)) and isdefined("form.filtro_PCRhasta") and Len(Trim(form.filtro_PCRhasta))>
			and <cf_dbfunction name="to_date00" args="a.PCRdesde"> = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PCRdesde)#">
			and <cf_dbfunction name="to_date00" args="a.PCRhasta"> = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PCRhasta)#">
		<cfelseif isdefined("form.filtro_PCRdesde") and Len(Trim(form.filtro_PCRdesde))>
			and <cf_dbfunction name="to_date00" args="a.PCRdesde"> = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PCRdesde)#">
		<cfelseif isdefined("form.filtro_PCRhasta") and Len(Trim(form.filtro_PCRhasta))> 
			and <cf_dbfunction name="to_date00" args="a.PCRhasta"> = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PCRhasta)#">
		</cfif>
	</cfif>
	order by a.OficodigoM, a.Cmayor, a.PCRregla
</cfquery>

<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
	<cfset PageNum_lista = Form.PageNum_lista>
<cfelseif isdefined("Url.PageNum_lista") and Len(Trim(Url.PageNum_lista))>
	<cfset PageNum_lista = Url.PageNum_lista>
<cfelse>
	<cfset PageNum_lista = 1>
</cfif>

<cfif MaxRows LT 1>
	<cfset MaxRows = rsReglas.RecordCount>
</cfif>
<cfif MaxRows LT 1>
	<cfset MaxRows_lista = 1>
<cfelse>
	<cfset MaxRows_lista = MaxRows>
</cfif>
<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(rsReglas.RecordCount,1))>		
<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,rsReglas.RecordCount)>

<cfset numChecks = (EndRow_lista + 1) - StartRow_lista>

<cfset TotalPages_lista = Ceiling(rsReglas.RecordCount/MaxRows_lista)>
<cfif Len(Trim(CGI.QUERY_STRING)) GT 0>
	<cfset QueryString_lista='&'&CGI.QUERY_STRING>
<cfelse>
	<cfset QueryString_lista="">
</cfif>
<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>

<cfif Len(Trim(navegacion)) NEQ 0>
	<cfset nav = ListToArray(navegacion, "&")>
	<cfloop index="nv" from="1" to="#ArrayLen(nav)#">
		<cfset tempkey = ListGetAt(nav[nv], 1, "=")>
		<cfset tempPos1 = ListContainsNoCase(QueryString_lista,"?" & tempkey & "=")>
		<cfset tempPos2 = ListContainsNoCase(QueryString_lista,"&" & tempkey & "=")>
		<!--- 
			Chequear substrings duplicados en el contenido de la llave
		--->
		<cfif tempPos1 EQ 0 and tempPos2 EQ 0>
		  <cfset QueryString_lista=QueryString_lista&"&"&nav[nv]>
		</cfif>
	</cfloop>
</cfif>

<script language="javascript" type="text/javascript">
	
	function infoRegla(regla)
	{
		var pagina = "popup-keys.cfm?PCRid="+regla+"&LvarGrp="+<cfoutput>#LvarGrp#</cfoutput>;
		//window.open(pagina,"Información_de_la_Regla","menubar=no,width=430,height=360,toolbar=no");
		window.open(pagina,'Informacion','left=300%,top=200%,scrollbars=yes,resizable=no,width=650,height=290');
	}
	
	/*RESTAURAR REGLAS*/
	function restaurarRegla(regla,id)
	{
		if(id == 1)
		{
			if(confirm('¿Este proceso restaurará la regla y todas las reglas hijas'))
			{
				funRestore(regla);
			}
		}
		else
		{
			if(confirm('¿Desea restaurar la regla?'))
			{
				funRestore(regla);
		    }
		}
	}
	
	function funRestore(regla)
	{
		document.formLista.PCRid.value = regla;
		document.formLista.RestoreRule.value = 1;		
		document.formLista.action='AdminReglas-sql.cfm';
		document.formLista.submit();
	}

	function valida_checks_padres(numPadres,id)
	{
		document.formLista.lstChecks.value = '';
		for (i = 0; i < numPadres; i++)
		{	
			csc = i+1;
			if ((eval('document.formLista.chkMasivoPadres' + csc + '.checked')))
			{ 
				if (document.formLista.lstChecks.value == '')
					document.formLista.lstChecks.value = document.formLista.lstChecks.value + eval('document.formLista.chkMasivoPadres' + csc).name;
				else
					document.formLista.lstChecks.value = document.formLista.lstChecks.value + ',' + eval('document.formLista.chkMasivoPadres' + csc).name;				
			}					
			VcantHijos = eval('document.formLista.chkMasivoPadres' + csc).value.split(',');
			valida_checks_hijos(VcantHijos[0],csc);
		}
		if (document.formLista.lstChecks.value == '')
			alert('Debe Seleccionar al menos una regla.!');
		else
		{
			if(id==1)
			{
				if(confirm('Este proceso eliminará todas las reglas seleccionadas y sus reglas hijas.\nPara recuperar dichas reglas se cuenta con un maximo de <cfoutput>#LvarDias#</cfoutput> días y se \nrealiza en la opción de restaurar reglas.\n   ¿Desea realmente eliminar masivamente las reglas de validación?'))
				{
					document.formLista.bajaMasivo.value = 1;
					document.formLista.action='AdminReglas-sql.cfm';
					document.formLista.submit();
				}
			}
			
			if(id==2)
			{
				if(confirm('¿Desea realmente eliminar masivamente las reglas de validación seleccionadas?'))
				{
					document.formLista.BajarMasivoR.value = 1;
					document.formLista.action='AdminReglas-sql.cfm';
					document.formLista.submit();
				}
			}
			
			if(id==3)
			{
				if(confirm('Este proceso restaura las reglas seleccionadas.¿Desea Continuar?'))
				{
					document.formLista.RestoreMasive.value = 1;
					document.formLista.action='AdminReglas-sql.cfm';
					document.formLista.submit();
				}
			}
			
		}
	}
	function valida_checks_hijos(cantHijos,cscPadre)
	{
		for (j = 0; j < cantHijos; j++)
		{
			hcsc = j+1;
			if ((eval('document.formLista.chkHijos' + cscPadre + '_' + hcsc + '.checked')))
			{
				if (document.formLista.lstChecks.value == '')
					document.formLista.lstChecks.value = document.formLista.lstChecks.value + eval('document.formLista.chkHijos' + cscPadre + '_' + hcsc).name;
				else
					document.formLista.lstChecks.value = document.formLista.lstChecks.value + ',' + eval('document.formLista.chkHijos' + cscPadre + '_' + hcsc).name;
			}
		}
	}
	
	function eliminarRegla(idRegla,id) 
	{
		if(id == 1)
		{
			if(confirm('¿Desea realmente eliminar la regla Padre?\nEste proceso eliminará todas las reglas hijas'))
			{
				funcDelete(idRegla);
			}
		}
		else
		{
			if(confirm('¿Desea eliminar la regla?'))
			{
				funcDelete(idRegla);
		    }
		}
	}
	
	function funcDelete(id)
	{
		document.formLista.PCRid.value = id;
		document.formLista.bajaRule.value = 1;		
		document.formLista.action='AdminReglas-sql.cfm';
		document.formLista.submit();
	}
	
	function funcMarcaTodos(numPadres) 	
	{
		if(document.formLista.chkMasivo.checked)
		{
			for (i = 0; i < numPadres; i++)
			{	
				csc = i+1;
				if ((!eval('document.formLista.chkMasivoPadres' + csc + '.checked')))
				{ 
					eval('document.formLista.chkMasivoPadres' + csc).checked = 1;		
					VcantHijos = eval('document.formLista.chkMasivoPadres' + csc).value.split(',');
					MarcaTodosHijos(VcantHijos[0],csc);
				}								
			}
		}	
		else
		{
			for (i = 0; i < numPadres; i++)
			{	
				csc = i+1;			
				if ((eval('document.formLista.chkMasivoPadres' + csc + '.checked')))
				{ 
					eval('document.formLista.chkMasivoPadres' + csc).checked = 0;	
					VcantHijos = eval('document.formLista.chkMasivoPadres' + csc).value.split(',');				
					MarcaTodosHijos(VcantHijos[0],csc);
				}				
			}			
		}	
	}
	
	function MarcaTodosHijos(cantHijos,cscPadre)
	{		
		for (j = 0; j < cantHijos; j++)
		{
			hcsc = j+1;
			if ((eval('document.formLista.chkMasivoPadres' + cscPadre + '.checked')))
			{
				eval('document.formLista.chkHijos' + cscPadre + '_' + hcsc).checked = 1;				
			}
			else
			{
				eval('document.formLista.chkHijos' + cscPadre + '_' + hcsc).checked = 0;
			}			
		}		
	}	
			

	
	function editarRegla(PCRid) {
		document.formLista.PCRid.value = PCRid;
		document.formLista.submit();
	}

	function funcFiltrar() {
		document.formLista.PageNum_lista.value = '1';
		document.formLista.submit();
	}

	function showChildren(PCRid) {
		var tr = null, name = null, mostrar = false, continuar = true, i = 1;
		var img = document.getElementById("img_" + PCRid);
		tr = document.getElementById("tr_" + PCRid + "_1");
		mostrar = (tr.style.display == "none");
		img.src = (mostrar ? "../../imagenes/abajo.gif" : "../../imagenes/derecha.gif");
		while (continuar) {
			name = "tr_" + PCRid + "_" + i;
			tr = document.getElementById(name);
			if (tr) {
				tr.style.display = (mostrar ? "" : "none");
			} else {
				continuar = false;
			}
			i = i + 1;
		}
	}
	
	function VerFilas(filas)
	{
		document.formLista.MaxRows.value = filas;
		document.formLista.submit();
	}

</script>

<style type="text/css">
	.topBorder { 
		border-top: 1px solid black; 
		background-color: #C7E8F8;
	}
	.bottomBorder { 
		border-bottom: 1px solid black; 
		background-color: #C7E8F8;
	}
	.bothBorder { 
		border-top: 1px solid black; 
		border-bottom: 1px solid black; 
		background-color: #C7E8F8;
	}
	.noBorder { 
		background-color: #C7E8F8;
	}
	.reglaSeleccionada { 
		background-color: #FAF9D8;
	}
</style>

<cfoutput>
	<!--- Filtros ---->
	<form name="formLista" method="post" action="#CurrentPage#" style="margin: 0;">
		<input type="hidden" name="StartRow_lista" value="#StartRow_lista#">
		<input type="hidden" name="PageNum_lista" value="#PageNum_lista#">
      	<input type="hidden" name="PCRid" value="">
        <input type="hidden" name="bajaRule" value="">
        <input type="hidden" name="RestoreRule" value="">
		<input type="hidden" name="bajaMasivo" value="">
        <input type="hidden" name="RestoreMasive" value="">
        <input type="hidden" name="BajarMasivoR" value="">
        <input type="hidden" name="MaxRows" value="#MaxRows#">
		<cfif isdefined("LvarRestaurar")>
    	    <input type="hidden" name="restaurar" value="2">
        <cfelse>
    	    <input type="hidden" name="restaurar" value="1">
        </cfif>
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr class="areaFiltro">
			<td width="2%">&nbsp;</td>
            <td width="2%">&nbsp;</td>
			<td width="3%">&nbsp;</td>
            <td width="3%">&nbsp;</td>
			<td width="8%"><strong>Oficina</strong></td>
			<!--- <td width="25%"><strong>Mayor</strong></td> --->
			<td width="45%"><strong>Regla</strong></td>
			<td width="8%" align="center"><strong>V&aacute;lida</strong></td>
			<td width="10%" align="center"><strong>Desde</strong></td>
			<td width="10%" align="center"><strong>Hasta</strong></td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%"><strong>Ver</strong></td>
			
			<td colspan="3">&nbsp;</td>
		  </tr>
		  <tr class="areaFiltro" height="25">
          	<!---Check de eliminacion masiva de las reglas escogidas--->
			<td>
            	<input 	type="checkbox" 
                        name="chkMasivo" 
                        id="chkMasivo" 
                        title="Check para realizar la eliminacion masiva de las reglas" 
                        onclick="javascript: funcMarcaTodos(<cfoutput>#numChecks#</cfoutput>);"/>
			</td>
			<td>&nbsp;</td>
            <td>&nbsp;</td>
			<td><input type="text" name="filtro_OficodigoM" size="11" maxlength="10" value="<cfif IsDefined("form.filtro_OficodigoM") and Len(Trim("form.filtro_OficodigoM"))>#form.filtro_OficodigoM#</cfif>"></td>
			<!--- <td>
				<cfset ctamayor = "">
				<cfif IsDefined("form.filtro_Cmayor") and Len(Trim("form.filtro_Cmayor"))>
					<cfset ctamayor = form.filtro_Cmayor>
				</cfif>
				<cf_sifCuentasMayor form="formLista" Cmayor="filtro_Cmayor" size="30" idquery="#ctamayor#">
			</td> --->
			<td><input type="text" name="filtro_PCRregla" size="70" value="<cfif IsDefined("form.filtro_PCRregla") and Len(Trim("form.filtro_PCRregla"))>#form.filtro_PCRregla#</cfif>"></td>
			<td align="center">
				<select name="filtro_PCRvalida" id="filtro_PCRvalida">
					<option value="">Todos</option>
					<option value="1" <cfif isdefined("Form.filtro_PCRvalida") and Form.filtro_PCRvalida EQ "1"> selected</cfif>>S&iacute;</option>
					<option value="0" <cfif isdefined("Form.filtro_PCRvalida") and Form.filtro_PCRvalida EQ "0"> selected</cfif>>No</option>
				</select>
			</td>
			<td align="center">
				<cfif IsDefined("Form.filtro_PCRdesde") and Len(Trim(Form.filtro_PCRdesde))>
					<cfset fecha = LSDateFormat(Form.filtro_PCRdesde,'dd/mm/yyyy')>
				<cfelse>
					<cfset fecha ="">
				</cfif>
				<cf_sifcalendario name="filtro_PCRdesde" form="formLista" value="#fecha#">
			</td>
			<td align="center">
				<cfif IsDefined("Form.filtro_PCRhasta") and Len(Trim(Form.filtro_PCRhasta))>
					<cfset fecha2 = LSDateFormat(Form.filtro_PCRhasta,'dd/mm/yyyy')>
				<cfelse>
					<cfset fecha2 = "">
				</cfif>
				<cf_sifcalendario name="filtro_PCRhasta" form="formLista" value="#fecha2#">
			</td>
			<td align="center">
				<input type="submit" name="btnFiltrar" value="Filtrar" onClick="javascript: return funcFiltrar();">
			</td>

			<td align="right" class="fileLabel" nowrap>
				<input name="FecMayores" type="checkbox" id="FecMayores" <cfif IsDefined("Form.FecMayores")> checked </cfif>>
			</td>
			<td>
				<label for="FecMayores">Fechas Mayores</label>
			</td>
              <td colspan="2" align="left">
                      <select name="Lineas" onChange="javascript:VerFilas(this.value)">
                        <option value="25" <cfif MaxRows EQ "25"> selected</cfif>>25</option>
                        <option value="50" <cfif MaxRows EQ "50"> selected</cfif>>50</option>
                        <option value="100" <cfif MaxRows EQ "100"> selected</cfif>>100</option>
                    </select>                                    	
                </td>               
			<td colspan="3">&nbsp;</td>

		  </tr>
		<cfif rsReglas.recordCount>
			<cfset expander = 0>
            
            <cfset chkpadre = 1>
            
			<cfloop query="rsReglas" startrow="#StartRow_lista#" endrow="#StartRow_lista+MaxRows_lista-1#">
			  
			  <cfset llave = rsReglas.PCRid>
			  <cfif modo EQ "CAMBIO" and Form.PCRid EQ llave>
			  	<cfset estilo = "reglaSeleccionada">
			  <cfelseif rsReglas.currentRow MOD 2>
			  	<cfset estilo = "listaNon">
			  <cfelse>
			  	<cfset estilo = "listaPar">
			  </cfif>
			  <tr class="#estilo#" onMouseOver="javascript: this.className='listaParSel';" onMouseOut="javascript: this.className='#estilo#';">
				<!---Check de eliminacion masiva de las reglas Padres--->
                <td><input 	type="checkbox" 
                			align="left" 
                            name="chkMasivoPadres<cfoutput>#chkpadre#</cfoutput>" 
                            id="chkMasivoPadres<cfoutput>#chkpadre#</cfoutput>"
                            value="<cfoutput>#rsReglas.cantNivel2#,#rsReglas.PCRid#</cfoutput>"
                            onclick="javascript: MarcaTodosHijos(<cfoutput>#rsReglas.cantNivel2#</cfoutput>,<cfoutput>#chkpadre#</cfoutput>);" 
                            title="Check para realizar la eliminacion de reglas padres"></td>
				<!---X para eliminar la regla Padre--->
                <td><a href="javascript: eliminarRegla(#rsReglas.PCRid#,1);"><img src="/cfmx/sif/imagenes/Borrar01_S.gif" border="0" title="Eliminar Regla Padre"></a></td>
                <td align="center">
					<cfif rsReglas.cantNivel2 GT 0>
						<a href="javascript: showChildren('#llave#');">
							<img id="img_#llave#" border="0" src="../../imagenes/derecha.gif" title="Mostrar/Ocultar Reglas de Nivel 2">
						</a>
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td>#rsReglas.OficodigoM#</td>
				<!--- <td>#rsReglas.Cmayor#</td> --->
				<td>#rsReglas.PCRregla#</td>
				<td align="center">#rsReglas.PCRvalida#</td>
				<td align="center">#LSDateFormat(rsReglas.PCRdesde,'dd/mm/yyyy')#</td>
				<td align="center">#LSDateFormat(rsReglas.PCRhasta,'dd/mm/yyyy')#</td>
				<td align="center">
					<cfif isdefined("LvarRestaurar")>
                            <a href="javascript: infoRegla('#llave#');">
                                <img src="../../imagenes/Help01_T.gif" width="25" height="23" border="0" style="margin-top: 0px; position: static; top: 7px;" title="Informaci&oacute;n de la Regla"/>   
                            </a>
                    <cfelse>
                            <a href="javascript: editarRegla('#llave#');">
                            <img border="0" src="../../imagenes/iedit.gif" title="Editar Regla">
                            </a>
                    </cfif>
                </td>
                <cfif isdefined("LvarRestaurar")>
                    <td colspan="3">
	                    <a href="javascript: restaurarRegla('#llave#',1);">
    		                <img border="0" src="../../imagenes/undo.small.png" title="Restaurar regla Padre"></a>
                    </td>
                <cfelse>
                	<td colspan="3">&nbsp;</td>
                </cfif>
			  </tr>
			  <cfif rsReglas.cantNivel2 GT 0>
				<cfquery name="rsReglasHijas" datasource="#session.DSN#">
					select a.PCRid, 
						   a.Ecodigo, 
						   a.Cmayor, 
						   a.PCEMid, 
						   a.OficodigoM, 
						   a.PCRref, 
						   a.PCRdescripcion, 
						   a.PCRregla, 
						   case when a.PCRvalida = 1 then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>' end as PCRvalida, 
						   a.PCRdesde, 
						   a.PCRhasta 
					from #LvarPCReglas# a 
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.PCRref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llave#">
					and a.PCRid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#llave#">
					order by a.PCRid
				</cfquery>
                
                <cfset chkhijo = 1>
                
				<cfloop query="rsReglasHijas">
				  
				  <cfset class = "noBorder">
				  <cfif rsReglasHijas.currentRow EQ 1 and rsReglasHijas.currentRow EQ rsReglasHijas.recordCount>
					  <cfset class = "bothBorder">
				  <cfelseif rsReglasHijas.currentRow EQ 1>
					  <cfset class = "topBorder">
				  <cfelseif rsReglasHijas.currentRow EQ rsReglasHijas.recordCount>
					  <cfset class = "bottomBorder">
				  </cfif>
				  <cfif modo EQ "CAMBIO" and Form.PCRid EQ rsReglasHijas.PCRid>
				  	  <cfset expander = llave>
				  </cfif>
				  <tr id="tr_#llave#_#rsReglasHijas.currentRow#" style="display: none;" <cfif modo EQ "CAMBIO" and Form.PCRid EQ rsReglasHijas.PCRid>class="reglaSeleccionada"</cfif>>
					<td>&nbsp;</td>
                    <!---Check de eliminacion masiva de las reglas Hijas--->
					<td><input 		type="checkbox" 
                    				align="left" 
                                    id="chkHijos<cfoutput>#chkpadre#_#chkhijo#</cfoutput>" 
                                    name="chkHijos<cfoutput>#chkpadre#_#chkhijo#</cfoutput>" 
                                    value="<cfoutput>#chkpadre#_#chkhijo#,#rsReglasHijas.PCRid#</cfoutput>"
                                    title="Check para realizar la eliminacion de reglas hijas" /></td>
                    <!---X Borrado reglas Hijas--->
                    <td><a href="javascript: eliminarRegla(#rsReglasHijas.PCRid#,2); "><img src="/cfmx/sif/imagenes/Borrar01_S.gif" border="0" title="Eliminar Regla Hija"></a></td>
					
                    <td <cfif Len(Trim(class))>class="#class#"</cfif>>&nbsp;&nbsp;&nbsp;#rsReglasHijas.OficodigoM#</td>
					<!--- <td <cfif Len(Trim(class))>class="#class#"</cfif>>#rsReglasHijas.Cmayor#</td> --->
					<td <cfif Len(Trim(class))>class="#class#"</cfif>>#rsReglasHijas.PCRregla#</td>
					<td align="center" <cfif Len(Trim(class))>class="#class#"</cfif>>#rsReglasHijas.PCRvalida#</td>
					<td align="center" <cfif Len(Trim(class))>class="#class#"</cfif>>#LSDateFormat(rsReglasHijas.PCRdesde,'dd/mm/yyyy')#</td>
					<td align="center" <cfif Len(Trim(class))>class="#class#"</cfif>>#LSDateFormat(rsReglasHijas.PCRhasta,'dd/mm/yyyy')#</td>
					<cfif isdefined("LvarRestaurar")>
                        <td align="center">
                            <a href="javascript: infoRegla('#rsReglasHijas.PCRid#');">
                                <img src="../../imagenes/Help01_T.gif" width="25" height="23" border="0" style="margin-top: 0px; position: static; top: 7px;" title="Informaci&oacute;n de la Regla"/>   
                            </a>
                        </td>                    
                    <cfelse>
                    	<td align="center">
                            <a href="javascript: editarRegla('#rsReglasHijas.PCRid#');">
                                <img border="0" src="../../imagenes/iedit.gif" title="Editar Regla">
                            </a>
						</td>
                    </cfif>
                    
					<cfif isdefined("LvarRestaurar")>
                        <td colspan="3">
                       		 <a href="javascript: restaurarRegla('#rsReglasHijas.PCRid#',0);">
    		               		 <img border="0" src="../../imagenes/undo.small.png" title="Restaurar Regla Hija"></a>
                        </td>
                    <cfelse>
                 	   <td colspan="3">&nbsp;</td>
                    </cfif>
				  </tr>
	                <!--- Consecutivo de Hijos --->
                	<cfset chkhijo = chkhijo + 1>
                </cfloop>
			  </cfif>
				<!--- Consecutivo de Padres --->
             	<cfset chkpadre = chkpadre + 1>
            
            </cfloop>
		    <tr>
			  <td colspan="12">&nbsp;</td>
		  	</tr>
			<tr> 
			  <td align="center" colspan="12">
					<cfset URLtoken = "&btnElegirGrp=1&cboGrupos=#LvarGrp#">				
                    <cfset pos= #find(URLtoken,QueryString_lista,1)#>
    
                    <cfset LvarToken = "">
                    <cfif pos eq 0>
                        <cfset LvarToken = URLtoken>
                    </cfif>
                    
                    <cfset LvarRetTipos = "">
                    <cfif (isdefined("Form.RetTipos") and Form.RetTipos eq 1) or
                          (isdefined("URL.RetTipos") and URL.RetTipos eq 1)>
    
                        <cfset URLRetTipos = "&RetTipos=1">
                        <cfset pos= #find(URLRetTipos,QueryString_lista,1)#>				
                          
                        <cfif pos eq 0>
                            <cfset LvarRetTipos = "&RetTipos=1">
                        </cfif>					  
                    </cfif>
				
				<cfif PageNum_lista GT 1>
				  <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista##LvarToken##LvarRetTipos#" tabindex="-1"><img src="/cfmx/sif/imagenes/First.gif" border="0"></a> 
				</cfif>
				<cfif PageNum_lista GT 1>
				  <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##LvarToken##LvarRetTipos##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Previous.gif" border="0"></a> 
				</cfif>
				<cfif PageNum_lista LT TotalPages_lista>
				  <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##LvarToken##LvarRetTipos##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Next.gif" border="0"></a> 
				</cfif>
				<cfif PageNum_lista LT TotalPages_lista>
				  <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##LvarToken##LvarRetTipos##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Last.gif" border="0"></a> 
				</cfif> 
			  </td>
			</tr>
		<cfelse>
		  <tr>
			<cfif isdefined("LvarRestaurar")>
        		<td colspan="12" align="center" class="tituloAlterno">--- NO SE ENCONTRARON REGLAS ELIMINADAS PARA ESTE GRUPO ---</td>
            <cfelse>
            		<td colspan="12" align="center" class="tituloAlterno">--- NO SE ENCONTRARON REGISTROS ---</td>
            </cfif>
		
		  </tr>
		</cfif>
		  <tr>
			<td colspan="12">&nbsp;</td>
		  </tr>
		</table>
		
		<cfif isdefined("Form.RetTipos") and Form.RetTipos eq 1>
			<input type="hidden" name="RetTipos" value="1">
		</cfif>
		<cfif isdefined("btnElegirGrp")>
			<input type="hidden" name="btnElegirGrp" value="1">
		</cfif>     
		<cfif isdefined("LvarGrp")>
            <input type="hidden" name="cboGrupos" value="<cfoutput>#LvarGrp#</cfoutput>">
            <input type="hidden" name="LvarGrp" value="<cfoutput>#LvarGrp#</cfoutput>">
        </cfif>        
        <input type="hidden" name="lstChecks">
		<center>
			<cfif isdefined("LvarRestaurar")>
                    <input type="button" name="btRestaurar" id="btRestaurar" class="btnNormal" value="Restaurar Masivo" onclick="javascript:valida_checks_padres(<cfoutput>#numChecks#</cfoutput>,3)">
            		<input type="button" name="Borrar_MasivoR" id="Borrar_MasivoR" class="btnNormal" value="Borrar Masivo" onclick="javascript:valida_checks_padres(<cfoutput>#numChecks#</cfoutput>,2)">             
            <cfelse>
            	<input type="button" name="Borrar_Masivo" id="Borrar_Masivo" class="btnNormal" value="Borrar Masivo" onclick="javascript:valida_checks_padres(<cfoutput>#numChecks#</cfoutput>,1)">         
            </cfif>  
		</center>        
        <br />
        
        
	</form>
</cfoutput>

<cfif rsReglas.recordCount and expander NEQ 0>
	<cfoutput>
	<script language="javascript" type="text/javascript">
		showChildren('#expander#');
	</script>
	</cfoutput>
</cfif>
