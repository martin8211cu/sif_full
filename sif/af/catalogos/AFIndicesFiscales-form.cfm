<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
		and Pcodigo = 50
		and Mcodigo = 'GN'
</cfquery>
<cfset rsPeriodos = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodos,3)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-2,1)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-1,2)>
<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor+0,3)>

<cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor" returnvariable="LvarVSvalor">
<cfquery name="rsQueryLista" datasource="#session.dsn#">
	select 
		afif.AFFperiodo, 
		afif.AFFMes, 
		avg(afif.AFFindice) as IndiceProm,
        case afif.AFFMes
            when  1 then 'Enero'
            when  2 then 'Febrero'
            when  3 then 'Marzo'
            when  4 then 'Abril'
            when  5 then 'Mayo'
            when  6 then 'Junio'
            when  7 then 'Julio'
            when  8 then 'Agosto'
            when  9 then 'Setiembre'
            when  10 then 'Octubre'
            when  11 then 'Noviembre'
            when  12 then 'Diciembre'
           end as Mes
	from AFIndicesFiscales afif
	where afif.Ecodigo = #session.Ecodigo#
    	<cfif isdefined ("form.filter") and len(trim(form.filter))>
			and afif.AFFperiodo = #form.AFFperiodo#
		</cfif>		
	group by afif.AFFperiodo, afif.AFFMes
</cfquery>  

<!--- Definición del Modo de la Forma --->
<cfif isdefined("form.AFFperiodo") and isdefined("form.AFFMes")>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif isdefined("url.AFFMes") and not isdefined("form.AFFMes")>
	<cfset form.AFFMes = url.AFFMes>
</cfif>

<cfif isdefined("url.filter") and not isdefined("form.filter")>
	<cfset form.filter = url.filter>
</cfif>

<!--- Meses --->
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a
		inner join VSidioma b 
		  on a.Iid = b.Iid	 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<!---Form--->
<cfif modo neq "ALTA">
	<!--- Como existe 1 registro por cada periodo mes,
	 pero esta forma esta hecha para modificar todos a la vez,
	 se toma el primero para el control multiusuario.
	--->
	<cfquery name="rsAFIndices" datasource="#Session.DSN#" maxrows="1">
		select AFFperiodo, AFFMes, AFFindice, ts_rversion  
		from AFIndicesFiscales
		where Ecodigo      = #Session.Ecodigo#
			and AFFperiodo = #form.AFFperiodo#
			and AFFMes     = #form.AFFMes#			
	</cfquery>
</cfif>

<cfquery name="Periodo" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 50
		and Mcodigo = 'GN'
</cfquery>

<cfquery name="rsMes" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and Pcodigo = 60
		and Mcodigo = 'GN'
</cfquery>
<!---JavaScript--->
<script src="/cfmx/sif/js/utilesMonto.js"></script>

<!---Form--->
<cfoutput>
<form action="AFIndicesFiscales-SQL.cfm" method="post" name="form1" onsubmit="return funcComprobarIndice()">
	<input type="hidden" name="filter" id="filter" value="">
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="3">
		<tr>
        	<td>&nbsp;</td>
			<td align="right"><strong>Periodo:</strong></td>
			<td align="center"><font color="red">*</font><strong>Mes:</strong></td>
			<td><font color="red">*</font><strong>&Iacute;ndice:</strong></td>
            <td>&nbsp;</td>
		</tr>
		<tr nowrap="nowrap">
        	<td>&nbsp;</td>
			<td valign="top" align="right" width="270px">
				<!---<select name="AFFperiodo">
					<cfloop query="rsPeriodos">
					<option value="#Pvalor#" <cfif rsPeriodos.Pvalor eq form.AFFperiodo>selected</cfif>>#Pvalor#</option>
					</cfloop>
				</select>--->
                <input type="hidden" id="Periodo" name="Periodo" value="#Periodo.Pvalor#">	
                <input type="text" id="AFFperiodo" name="AFFperiodo" size="10" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='0') {this.blur();}}" <cfif modo neq "ALTA">value="#form.AFFPeriodo#"</cfif>>			
			</td>
			<td valign="top" align="center">
				<select name="AFFMes">
					<cfloop query="rsMeses">
						<option value="#Pvalor#" <cfif modo neq "ALTA" and rsMeses.Pvalor eq form.AFFMes>selected</cfif>>#Pdescripcion#</option>
					</cfloop>
					<!----<option value="1,2,3,4,5,6,7,8,9,10,11,12">--Todos--</option>---->
				</select>
                <input type="hidden" id="Mes" name="Mes" value="<cfoutput>#rsMes.Pvalor#</cfoutput>">	
			</td>
			<td valign="top">
				<input name="AFFindice" type="text" value="<cfif modo neq 'ALTA'>#rsAFIndices.AFFindice#</cfif>" size="14" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,6); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,6)){ if(Key(event)=='13') {this.blur();}}">
			</td>
            <td>&nbsp;</td>
		</tr>    
        <tr>
        	<td valign="top" colspan="7">
            	&nbsp;
            	<cf_botones modo=#modo# sufijo="Indice" include="Filtrar" exclude="Baja">
           	</td>
        </tr>
	</table>
	<cfif modo NEQ "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsAFIndices.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
	<cfif modo eq "CAMBIO">
		<script language="JavaScript1.2" type="text/javascript">
				document.form1.AFFperiodo.disabled = true;
				document.form1.AFFMes.disabled = true;
		</script>	
	</cfif>
</form>

</cfoutput>

<cf_qforms form="form1" >
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	objForm.AFFperiodo.description="Período";
	objForm.AFFMes.description="Mes";	
	objForm.AFFindice.description="Indice";
	
	function deshabilitarValidacion(){
		objForm.AFFperiodo.required = false;
		objForm.AFFMes.required = false;
		objForm.AFFindice.required = false;
	}
	function habilitarValidacion(){
		objForm.AFFperiodo.required = true;
		objForm.AFFMes.required = true;
		objForm.AFFindice.required = true;
	}
	habilitarValidacion();
	//objForm.AFIindice.obj.focus();
	
	function funcFiltrarIndice(){
		document.form1.filter.value = "yes";
		deshabilitarValidacion();
		return true;
	}
	
	function funcEliminarIndice(){
		deshabilitarValidacion();
		return true;
	}
	
	function funcComprobarIndice(){
		periodo = document.form1.AFFperiodo.value;
		indice = document.form1.AFFMes.selectedIndex;
		mes = document.form1.AFFMes.options[indice].value;
		periodoAux = document.getElementById("Periodo").value;
		mesAux = document.getElementById("Mes").value;
		if(periodo > periodoAux ){
			alert("No se puede ingresar un indice para un periodo mayor al auxiliar");
			return false;
		}
		if(periodo == periodoAux){
			if(mes > mexAux){
				alert("No se puede ingresar un indice para un periodo y mes mayor al auxiliar");
				return false;
			}
		}
		if(periodo < 1900){
			alert("No se puede ingresar un indice fiscal para un periodo menor a 1900");
			return false;
		}
		else{
			return true;
		}
		
	}
	
	function funcCambioIndice(){
		if(document.form1.AFFperiodo.disabled)
			document.form1.AFFperiodo.disabled = false;
		if(document.form1.AFFMes.disabled)
			document.form1.AFFMes.disabled = false;
		return true;
	}
	//-->	
</script>