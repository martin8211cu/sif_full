

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CURP" Default="CURP" returnvariable="LB_CURP"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cliente" Default="Cliente" returnvariable="LB_Cliente"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="Monto" returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Parcialidades" Default="Parcialidades" returnvariable="LB_Parcialidades"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Observaciones" Default="Observaciones" returnvariable="LB_Observaciones"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripcion" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_aCondonar" Default="A Condonar" returnvariable="LB_aCondonar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_xCondonar" Default="Condonadas" returnvariable="LB_xCondonar"/>




<cfset EstadoCorteCalculoIntereses = 2>

<cfquery name="q_Tipo" datasource="#session.DSN#">
	select Tipo from CRCCuentas where id = #q_Condonacion.CRCCuentasid#
</cfquery>

<cfquery name="q_Corte" datasource="#session.DSN#">
	select codigo from CRCCortes 
		where 
			isNull(status,0) < #EstadoCorteCalculoIntereses#
			and Tipo = '#q_Tipo.Tipo#';
</cfquery>

<cfset CodCortes = []>
<cfloop query="q_Corte">
     <cfset CodCortes[#currentRow#] = #codigo#>
</cfloop>
<cfquery name="q_Transacciones" datasource="#session.DSN#">
	select 
			Distinct(B.CRCTransaccionid)
		,	SUBSTRING(A.Observaciones,0,30) as Observaciones
		,	SUBSTRING(A.Descripcion,0,30) as Descripcion
		,	A.fecha
		,	A.id
		,	A.CURP
		,	A.Cliente
		,	A.Monto
		, 	A.Parciales
		,	CONCAT (
				'<input type="checkbox" name="CHK_'
			,	A.id
			,	'" value="'
			,	A.id
			,	'" onchange="keepChecked(this)">'
			) as checkbox
		from CRCTransaccion A
		inner join CRCMovimientoCuenta B 
			on A.id = B.CRCTransaccionid
		where 
			B.Corte in ('#ArrayToList(CodCortes,"','")#') 
			and A.Ecodigo = #session.ecodigo#
			and A.CRCCuentasid = #q_Condonacion.CRCCuentasid#
			<cfif isdefined('form.filtro_fecha')><cfif form.filtro_fecha neq "">and CONVERT(date, A.Fecha) = <cfqueryparam cfsqltype="cf_sql_date" value="#form.filtro_fecha#"></cfif></cfif>
			<cfif isdefined('form.filtro_cliente')><cfif form.filtro_cliente  neq "">and A.Cliente like '%#form.filtro_cliente#%'</cfif></cfif>
			<cfif isdefined('form.filtro_monto')><cfif form.filtro_monto  neq "">and A.Monto like '%#form.filtro_monto#%'</cfif></cfif>
			<cfif isdefined('form.filtro_parcial')><cfif form.filtro_parcial  neq "">and A.Parciales like '%#form.filtro_parcial#%'</cfif></cfif>
			<cfif isdefined('form.filtro_observ')><cfif form.filtro_observ  neq "">and A.Observaciones like '%#form.filtro_observ#%'</cfif></cfif>
			<cfif isdefined('form.filtro_curp')><cfif form.filtro_curp  neq "">and A.CURP like '%#form.filtro_curp#%'</cfif></cfif>
			<cfif q_Condonacion.CondonacionAplicada eq 1>  and A.CRCCondonacionesid = #form.id# </cfif>
		order by fecha;
</cfquery>


<cfquery name="q_detalle" datasource="#session.DSN#">
	select CRCTransaccionid from CRCCondonacionDetalle where CRCCondonacionesid = #form.id#
</cfquery>

<cfset chk_ids=[]>
<cfloop query="#q_detalle#">
	<cfset ArrayAppend(chk_ids,q_detalle.CRCTransaccionid)>
</cfloop>
<cfset chk_ids=ArrayToList(chk_ids,",")>



<cfset counter = 0>
<cfset th = "font-size: 14px; background-color:##ccc;">
<cfset thleft = "#th# text-align:left">
<cfset thcenter = "#th# text-align:center">
<cfset thright = "#th# text-align:right">

<cfoutput>
<br/>
<br/>

<table>
	<input type="hidden" name="chk_id" value="<cfif isdefined('form.chk_id')>#form.chk_id#<cfelseif chk_ids neq "">#chk_ids#</cfif>">
	<tr>
		<td style="padding: 7px;;">#LB_Fecha#:&nbsp;</td>
			<td>
				<cfset fechaftr = ''>
				<cfif isdefined('form.filtro_fecha')><cfset fechaftr = form.filtro_fecha></cfif>
				<cf_sifcalendario form="form1" value="#fechaftr#" name="filtro_fecha" tabindex="1">
						<!---
						<input type="date" name="filtro_fecha" 
					value="<cfif isdefined('form.filtro_fecha')>#form.filtro_fecha#</cfif>"
				>
					--->
			</td>
		<td style="padding: 7px;;">#LB_CURP#:&nbsp;</td>
			<td><input type="text" name="filtro_curp" 
					value="<cfif isdefined('form.filtro_curp')>#form.filtro_curp#</cfif>"
				>
			</td>
		<td style="padding: 7px;;">#LB_Cliente#:&nbsp;</td>
			<td><input type="text" name="filtro_cliente" 
					value="<cfif isdefined('form.filtro_cliente')>#form.filtro_cliente#</cfif>"
				>
			</td>
		<td style="padding: 7px;;">#LB_Monto#:&nbsp;</td>
			<td><input size="10" type="text" name="filtro_monto" onkeypress="return soloNumeros(event);" 
					value="<cfif isdefined('form.filtro_monto')>#form.filtro_monto#</cfif>"
				>
			</td>
		<td style="padding: 7px;;">#LB_Parcialidades#:&nbsp;</td>
			<td><input size="5" type="text" name="filtro_parcial" onkeypress="return soloNumeros(event);" 
					value="<cfif isdefined('form.filtro_parcial')>#form.filtro_parcial#</cfif>"
				>
			</td>
		<td style="padding: 7px;;">#LB_Observaciones#:&nbsp;</td>
			<td><input type="text" name="filtro_observ" 
					value="<cfif isdefined('form.filtro_observ')>#form.filtro_observ#</cfif>"
				>
			</td>
		<td style="padding: 7px;;">&nbsp;</td> <td><input type="submit" name="Filtrar" value="Filtrar" > </td>
	</tr>
	<tr>
		<td colspan="12"> </td>
	</tr>
</table>

<cfset LB_Condonar = LB_aCondonar>

<cfinvoke component="commons.Componentes.pListas" method="pListaQuery"
	query="#q_Transacciones#"
	desplegar="Fecha,CURP,Cliente,Monto,Parciales,Observaciones,Descripcion,checkbox"
	etiquetas="#LB_Fecha#,#LB_CURP#,#LB_Cliente#,#LB_Monto#,#LB_Parcialidades#,#LB_Observaciones#,#LB_Descripcion#,<input type='checkbox' onclick='CheckAll(this.checked)'> #LB_Condonar#"
	formatos="D,S,S,M,S,S,S,S"
	align="left,left,left,left,left,left,left,left"
	usaAJAX="true"
	showLink="false"
	conexion="#session.dsn#"
	ira="Condonaciones_form.cfm"
	funcion_cambioPagina_ajax="checkPrevCHK();"
	keys="id">
</cfinvoke>

</cfoutput>

<script>

	var chkPrevIDs = document.getElementsByName('chk_id')[0].value.split(',');
	for(var i = 0; i < chkPrevIDs.length; i++){
		if((document.getElementsByName('CHK_'+chkPrevIDs[i])).length > 0){
			document.getElementsByName('CHK_'+chkPrevIDs[i])[0].checked = true;
		}
	}

	function checkPrevCHK(){
		var chkPrevIDs = document.getElementsByName('chk_id')[0].value.split(',');
		for(var i = 0; i < chkPrevIDs.length; i++){
			if((document.getElementsByName('CHK_'+chkPrevIDs[i])).length > 0){
				document.getElementsByName('CHK_'+chkPrevIDs[i])[0].checked = true;
			}
		}
	}
	
	
	function CheckAll(c){
		var $inputs = $(":input[name^='CHK_']");
		var DOM_inputs = $inputs.get();
		for(var i = 0; i < DOM_inputs.length; i++){
			DOM_inputs[i].checked = c;
			keepChecked(DOM_inputs[i]);
		}
	}
	
	function keepChecked(c){
		var ids = document.getElementsByName('chk_id')[0];
		var idArr = ids.value.split(',');
		
		if(c.checked){
			if(idArr.indexOf(c.value) < 0){
				idArr.push(c.value);
			}
		}else{
			idArr.splice(idArr.indexOf(c.value),1);
		}
		if(idArr.indexOf('') >= 0){idArr.splice(idArr.indexOf(''),1);}
		
		document.getElementsByName('chk_id')[0].value = idArr.toString();
		
		console.log(document.getElementsByName('chk_id')[0].value);
		
	}	
		
	function soloNumeros(e) {
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46)) { return true;}
         
        return /\d/.test(String.fromCharCode(keynum));
	}
</script>
