<cfif isdefined('url.PETid') and len(trim(url.PETid))>
	<cfset form.PETid=url.PETid>
</cfif>
<cfif modo neq 'ALTA' and isdefined('form.PETid') and len(trim(form.PETid))>
	<cfquery name="rsSelectDatosTrans" datasource="#session.dsn#">
		select Pid, PTid, DEid, PETfecha, ts_rversion
		from PETransacciones 
		where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.PETid#"> 
			and Ecodigo = #session.Ecodigo# and PETestado = 1
	</cfquery>
</cfif>
<cfif isdefined('rsSelectDatosTrans')>
	<cfset form.selectPeaje=rsSelectDatosTrans.Pid>
	<cfset form.selectTurno=rsSelectDatosTrans.PTid>
	<cfset PTid=rsSelectDatosTrans.PTid>
	<cfset PTid=rsSelectDatosTrans.PTid>
	<cfset PETfecha=LSDateFormat(rsSelectDatosTrans.PETfecha,'dd/mm/yyyy')>
<cfelse>
	<cfset form.selectPeaje="">
	<cfset form.selectTurno="">
	<cfset PTid="">
	<cfset PTid="">
	<cfset PETfecha = LSDateFormat(Now(),'dd/mm/yyyy')>
</cfif>
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cf_dbfunction name="to_char" args="d.DEid" returnvariable="DEidB">
<cfquery name="rsUsuario" datasource="#session.DSN#" >
	select 
	(select d.DEid 
	   from UsuarioReferencia b 
	 inner join DatosEmpleado d 
	     on b.Ecodigo = #session.EcodigoSDC# 
	  where b.Usucodigo = u.Usucodigo
	  and b.STabla	= 'DatosEmpleado' 
	  and b.llave = #preserveSingleQuotes(DEidB)# 
	  ) as DEid
	from Usuario u
		inner join DatosPersonales p
			on p.datos_personales = u.datos_personales
	where u.CEcodigo = #session.CEcodigo# 
	and u.Uestado = 1 
	and u.Usucodigo =  #session.usucodigo# 
</cfquery>
<cfif not len(trim(rsUsuario.DEid))>
<table align="center" border="0">
	<tr><td>
		No esta autorizado a ver este contenido. Debe de ser un empleado para ver este contenido
	</td>
	</tr>
	
	<td>
		<form method="post" action="listaRegistroMovimientos.cfm">
			<cf_botones modo="ALTA" include="Regresar" exclude="ALTA,Limpiar">
			<input name="modo" id="modo" value="ALTA" type="hidden" />
		</form>
		<cfabort>
	</td></tr>
</table>
</cfif>
<cfquery name="rsSelectDatosPeajes" datasource="#session.dsn#">
	select pe.Pid, p.Pcodigo #_Cat# ' - ' #_Cat# p.Pdescripcion as Descripcion
	from PEmpleado pe
    	inner join Peaje p on p.Pid = pe.Pid and p.Ecodigo = #session.Ecodigo#
	where pe.DEid = #rsUsuario.DEid#
</cfquery>
<cfif modo neq 'ALTA' and isdefined('form.PETid') and len(trim(form.PETid))>
	<cfset form.PETid=#form.PETid#>
</cfif>
<cfquery name="rsSelectDatosTurnos" datasource="#session.dsn#">
	select pt.PTid, pt.PTcodigo #_Cat# '  ' #_Cat#
		case when (pt.PThoraini/60) < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="pt.PThoraini/60"> else <cf_dbfunction name="to_char" args="pt.PThoraini/60">end
			#_Cat#':'#_Cat#
			case when pt.PThoraini -(pt.PThoraini/60)*60 < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="pt.PThoraini -(pt.PThoraini/60)*60"> else <cf_dbfunction name="to_char" args="pt.PThoraini -(pt.PThoraini/60)*60"> end
			#_Cat# ' - ' #_Cat#
			case when (pt.PThorafin/60) < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="pt.PThorafin/60"> else <cf_dbfunction name="to_char" args="pt.PThorafin/60"> end
			#_Cat#':'#_Cat#
			case when pt.PThorafin -(pt.PThorafin/60)*60 < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="pt.PThorafin -(pt.PThorafin/60)*60"> else <cf_dbfunction name="to_char" args="pt.PThorafin -(pt.PThorafin/60)*60"> end
		as Descripcion
	from PTurnos pt
	where pt.Ecodigo = #session.Ecodigo# and exists(select count(1) from  PETransacciones pet where pet.PTid = pt.PTid)
</cfquery>
<cfparam name="form.selectTurno" default="#rsSelectDatosTurnos.PTid#">
<cfparam name="form.selectPeaje" default="#rsSelectDatosPeajes.Pid#">
<cfform action="registroMovimientos_SQL.cfm" method="post" name="formEncabezado">
<table align="center" border="0">
	<tr> 
		<td>Fecha:</td>
		<td>
			<cf_sifcalendario name="fecha" value="#PETfecha#" tabindex="1" form="formEncabezado">
		</td>
		<td nowrap align="right">&nbsp;&nbsp;</td>
		<td nowrap align="right">Peaje:</td>
		<td>
			<cfif modo neq 'ALTA' and isdefined('form.PETid') and len(trim(form.PETid))>
				<cfloop query="rsSelectDatosPeajes">
				 	<cfif form.selectPeaje eq Pid>
						<input name="selectPeaje" value="<cfoutput>#Pid#</cfoutput>" type="hidden">
						<input name="selectPeajeD" value="<cfoutput>#Descripcion#</cfoutput>" type="text" readonly="true">
					</cfif>
				</cfloop>									
			<cfelse>
			<select name="selectPeaje">
			<option value="">-- Seleccione un Peaje --</option>
				<cfloop query="rsSelectDatosPeajes">
					<option value="<cfoutput>#Pid#</cfoutput>" <cfif form.selectPeaje eq Pid> selected="selected"</cfif>>
						<cfoutput>#Descripcion#</cfoutput>
					</option>
				</cfloop>									
			</select>
			</cfif>
		</td>
		<td nowrap align="right">&nbsp;&nbsp;</td>
		<td nowrap align="right">Turno:</td>
		<td>
			<cfif modo neq 'ALTA' and isdefined('form.PETid') and len(trim(form.PETid))>
				<cfloop query="rsSelectDatosTurnos">
				 	<cfif form.selectTurno eq PTid>
						<input name="selectTurno" value="<cfoutput>#PTid#</cfoutput>" type="hidden">
						<input name="selectTurnoD" value="<cfoutput>#Descripcion#</cfoutput>" type="text" size="45" align="right" readonly="true">
					</cfif>
				</cfloop>									
			<cfelse>
				<select name="selectTurno">
				<option value="">-- Seleccione un Turno --</option>
					<cfloop query="rsSelectDatosTurnos">
						<option value="<cfoutput>#PTid#</cfoutput>" <cfif form.selectTurno eq PTid> selected="selected"</cfif>>
							<cfoutput>#Descripcion#</cfoutput>
						</option>
					</cfloop>									
				</select>
			</cfif>
		<td>
	</tr>
	<tr>
		<td colspan="9">
			<cfset incluir="">
			<cfif modo neq 'ALTA'>
				<cfset incluir="Aplicar">
			</cfif>
			<cf_botones modo="#modo#" include="#incluir#">	
		<td>
	</tr>
	<tr> 
		<td colspan="9">
			<input type="hidden" id="modo" name="modo" value="<cfoutput>#modo#</cfoutput>" />
			<input type="hidden" id="Ecodigo" name="Ecodigo" value="<cfoutput>#session.Ecodigo#</cfoutput>" />
			<input type="hidden" id="MBUsucodigo" name="MBUsucodigo" value="<cfoutput>#session.usucodigo#</cfoutput>" />
			<input type="hidden" id="DEid" name="DEid" value="<cfoutput>#rsUsuario.DEid#</cfoutput>"/>
			<cfif modo neq "ALTA">
				<input type="hidden" id="PETid" name="PETid" value="<cfoutput>#form.PETid#</cfoutput>" />
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsSelectDatosTrans.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
			</cfif>
			
		</td>
	</tr>
</table>
<cfif modo neq 'ALTA' and isdefined('form.PETid') and len(trim(form.PETid))>
	<cfquery name="rsTotalDepositos" datasource="#session.dsn#">
		select coalesce(sum( PDTDmonto * PDTDtipocambio),0) Total
		from PDTDeposito
		where PETid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PETid#">
	</cfquery>
	<cfquery name="rsTotalVehiculos" datasource="#session.dsn#">
		select coalesce(sum(cat.PDTVcantidad * (pre.PPrecio * coalesce(TCcompra, 1)) * case when veh.PVoficial = '1' then 0 else 1 end),0) Total
			from PPrecio pre
				inner join PVehiculos veh
					on pre.PVid = veh.PVid
				inner join Peaje pea
					on pre.Pid = pea.Pid
				inner join Monedas m
				  on m.Mcodigo = pre.Mcodigo
				inner join PETransacciones enc
					inner join PTurnos tur
						on tur.PTid = enc.PTid 
				  on enc.Pid = pea.Pid 
				 left outer join Htipocambio htc 
					   on htc.Mcodigo = m.Mcodigo 
					   and htc.Ecodigo = #session.Ecodigo# 
					   and enc.PETfecha  BETWEEN htc.Hfecha and  htc.Hfechah
				inner join PDTVehiculos cat
					on cat.PETid = enc.PETid
					and cat.PVid = veh.PVid
			where enc.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PETid#"> 
	</cfquery>
	<cfset dif=rsTotalVehiculos.Total-rsTotalDepositos.Total>
	
	<cfset TVehiculo=rsTotalVehiculos.Total>
	<cfset TDeposito=rsTotalDepositos.Total>
	
<cfelse>
	<cfset dif=0>
	<cfset TVehiculo=0>
	<cfset TDeposito=0>
	
</cfif>




<input name="tdiferienciah" id="tdiferienciah" type="hidden" disabled="disabled" value="<cfoutput>#dif#</cfoutput>"/>
<input name="TVehiculo" id="TVehiculo" type="hidden" disabled="disabled" value="<cfoutput>#TVehiculo#</cfoutput>"/>
<input name="TDeposito" id="TDeposito"type="hidden" disabled="disabled" value="<cfoutput>#TDeposito#</cfoutput>"/>


</cfform>
<cfoutput>
<cf_qforms form='formEncabezado' objForm="objFormEncabezado">
<script language="javascript1.2" type="text/javascript">

	objFormEncabezado.fecha.description = "#JSStringFormat('Fecha')#";
	objFormEncabezado.selectPeaje.description = "#JSStringFormat('Peaje')#";
	objFormEncabezado.selectTurno.description = "#JSStringFormat('Turno')#";
	objFormEncabezado.fecha.required= true;
	objFormEncabezado.selectPeaje.required= true;
	objFormEncabezado.selectTurno.required = true;
	
	<cfif isdefined('url.msgError') and len(trim(url.msgError))>
		<cfoutput>alert('#url.msgError#');</cfoutput>
	</cfif>
	function funcAplicar(){
		var dif=parseFloat(objFormEncabezado.tdiferienciah.obj.value);
		var TVehiculo=parseFloat(objFormEncabezado.TVehiculo.obj.value);
		var TDeposito=parseFloat(objFormEncabezado.TDeposito.obj.value);		
		if( TVehiculo == 0 && TDeposito== 0 ){
		  alert("No se han registrado depositos ni movimientos");
		  return false;
		}
		if(dif==0){
			if(confirm("Desea aplicar el documento?"))
				return true;
			else
				return false;
		}else{
			if(confirm("Existe una diferencia de "+objFormEncabezado.tdiferienciah.obj.value +" entre los depositos y los totales según vehículos, desea aplicar el documento?")){
				if(objFormEncabezado.TDeposito.obj.value >= objFormEncabezado.TVehiculo.obj.value)
					return true;
				else
					return false; 
			}
		}
		return false;
	}
	function funcCambio(){
		var msj="";
		if(objFormEncabezado.selectPeaje.obj.value != #rsSelectDatosPeajes.Pid#){
			msj+="Según la cantidad de carrilles del peaje, estos podrán ser eliminados o agregados, puede que se pierdan datos.";
		}if(objFormEncabezado.selectTurno.obj.value != #rsSelectDatosTurnos.PTid#){
			msj+=" Los carriles cerrados correspondientes a este turno serán eliminados.";
		}
		if(objFormEncabezado.selectPeaje.obj.value != #rsSelectDatosPeajes.Pid# || objFormEncabezado.selectTurno.obj.value != #rsSelectDatosTurnos.PTid#){
			msj+=" Desea continuar?"
			if(confirm(msj))
				return true;
			else
				return false;
		}
	}
</script>
</cfoutput>
