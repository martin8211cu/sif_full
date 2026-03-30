<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<!---<cfset VR	= replace(VR,"RRRR","' #_Cat#  d.AFTDdescripcion  #_Cat# '","ALL")>--->
					
<cfquery name="rsSelectDatosPDTVehiculos" datasource="#session.dsn#">
	select pet.PETid, 
		p.Pcodigo #_Cat# ' - ' #_Cat# p.Pdescripcion as DesPeaje,
		case when pv.PVoficial = '1' then 0 else pp.PPrecio end as Costo, 
		p.Pcarriles,
		pv.PVid,
		pv.PVoficial,
		pv.PVcodigo #_Cat# ' ' #_Cat# pv.PVdescripcion as DesVehiculo,
		pdtv.PDTVid,
		pdtv.PDTVcarril, 
		pdtv.PDTVcantidad,
		m.Msimbolo
	from PETransacciones pet 
	   inner join PDTVehiculos pdtv on pdtv.PETid = pet.PETid
			inner join PVehiculos pv on pv.PVid = pdtv.PVid
	   inner join Peaje p 
	   		on p.Pid = pet.Pid and p.Ecodigo = #session.Ecodigo#
	   inner join PPrecio pp 
			on pp.Pid = p.Pid and pp.PVid = pv.PVid
       inner join Monedas m 
	   		on m.Mcodigo = pp.Mcodigo and  m.Ecodigo = #session.Ecodigo#
       left outer join Htipocambio htc 
	   		on htc.Mcodigo = m.Mcodigo and htc.Ecodigo = #session.Ecodigo#
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(PETfecha)#">  BETWEEN htc.Hfecha and  htc.Hfechah
	where pet.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.PETid#"> and pet.Ecodigo = #session.Ecodigo#
	order by pdtv.PDTVcarril, pdtv.PVid
</cfquery>
<cfquery name="rsTotalPorCarril" datasource="#session.dsn#">
	select enc.PETfecha Dia,tur.PTcodigo turno, pea.Pcodigo Peaje,cat.PDTVcarril carril, Sum(coalesce(cat.PDTVcantidad * (pre.PPrecio * coalesce(htc.TCcompra,1)) * case when veh.PVoficial = '1' then 0 else 1 end,0)) Dinero
	from PPrecio pre
		inner join PVehiculos veh
			on pre.PVid = veh.PVid
		inner join Peaje pea
			on pre.Pid = pea.Pid
		inner join Monedas m
			left outer join Htipocambio htc 
			   on htc.Mcodigo = m.Mcodigo 
			   and htc.Ecodigo = #session.Ecodigo# 
			   and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(PETfecha)#">  BETWEEN htc.Hfecha and  htc.Hfechah
		  on m.Mcodigo = pre.Mcodigo
		inner join PETransacciones enc
			inner join PTurnos tur
				on tur.PTid = enc.PTid 
		  on enc.Pid = pea.Pid 
		inner join PDTVehiculos cat
			on cat.PETid = enc.PETid
			and cat.PVid = veh.PVid
	where enc.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PETid#">
	group by enc.PETfecha,tur.PTcodigo, pea.Pcodigo,cat.PDTVcarril     
	order by enc.PETfecha,tur.PTcodigo, pea.Pcodigo,cat.PDTVcarril 
</cfquery>
<cfquery name="rsTotalPorVehiculo" datasource="#session.dsn#">
	select enc.PETfecha Dia,tur.PTcodigo turno, pea.Pcodigo Peaje,veh.PVid vehiculo, Sum(coalesce(cat.PDTVcantidad * (pre.PPrecio * coalesce(htc.TCcompra,1)) * case when veh.PVoficial = '1' then 0 else 1 end,0)) Dinero
	from PPrecio pre
		inner join PVehiculos veh
			on pre.PVid = veh.PVid
		inner join Peaje pea
			on pre.Pid = pea.Pid
		inner join Monedas m
			left outer join Htipocambio htc 
			   on htc.Mcodigo = m.Mcodigo 
			   and htc.Ecodigo = 1 
			   and <cf_dbfunction name="to_datetime" args="'#PETfecha#'">  BETWEEN htc.Hfecha and  htc.Hfechah
		  on m.Mcodigo = pre.Mcodigo
		inner join PETransacciones enc
			inner join PTurnos tur
				on tur.PTid = enc.PTid 
		  on enc.Pid = pea.Pid 
		inner join PDTVehiculos cat
			on cat.PETid = enc.PETid
			and cat.PVid = veh.PVid
	where enc.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PETid#">
	group by enc.PETfecha,tur.PTcodigo, pea.Pcodigo,veh.PVid     
	order by enc.PETfecha,tur.PTcodigo, pea.Pcodigo,veh.PVid  
</cfquery>
<cfset columnas="Carril">
<cfset desplegar="Carril">
<cfset formatos="I">
<cfset align="left">
<cfset idC="Carril">
<cfloop query="rsSelectDatosPDTVehiculos">
	<cfif not ListFind(columnas, 'C_'&#PVid#)>
		<cfset columnas&= ',' & 'C_'&#PVid#>
		<cfset desplegar&=',' & #DesVehiculo# & ' ' & #Msimbolo# &' ' & #NumberFormat(Costo,'9')#>
		<cfset formatos&=',' & "I">
		<cfset align&=',' & "right">
	</cfif>
</cfloop>
<cfquery name="rsMonedaLocal" datasource="#session.dsn#">
	select m.Msimbolo
		from Empresas e
			inner join Monedas m on m.Mcodigo = e.Mcodigo 
	where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfset columnas&=",Total">
<cfset desplegar&=",Totales en " & #rsMonedaLocal.Msimbolo# >
<cfset formatos&=",I">
<cfset align&=",right">
<cfset rsPDTVehiculos = QueryNew(columnas)>
<cfset temp = QueryAddRow(rsPDTVehiculos,rsSelectDatosPDTVehiculos.Pcarriles + 1)>
<cfset montoTotal=0>
<cfloop query="rsTotalPorCarril">
	<cfset temp = QuerySetCell(rsPDTVehiculos,'Total','<input value="#numberFormat(Dinero,',9.00')#" id="TV_#carril#" name="TV_#carril#" align="right" readonly="yes" />',carril)>
	<cfset montoTotal+=#Dinero#>
</cfloop>
<cfset temp = QuerySetCell(rsPDTVehiculos,'Total','<input value=" #numberFormat(montoTotal,',9.00')#" id="TT" name="TT" align="right" readonly="yes"/>',rsSelectDatosPDTVehiculos.Pcarriles + 1)>
<cfset temp = QuerySetCell(rsPDTVehiculos,'Carril','Total en ' & #rsMonedaLocal.Msimbolo#,rsSelectDatosPDTVehiculos.Pcarriles + 1)>
<cfloop query="rsTotalPorVehiculo">
	<cfset temp = QuerySetCell(rsPDTVehiculos, 'C_'&vehiculo ,'<input value="#numberFormat(Dinero,',9.00')#" id="TH_#vehiculo#" name="TH_#vehiculo#" align="right" readonly="yes"/>',rsSelectDatosPDTVehiculos.Pcarriles + 1)>
</cfloop>
<cfset input="">
<cfloop query="rsSelectDatosPDTVehiculos">
	<cfset VR = '<input type="text" maxlength="100" id="I_#PDTVid#" name="I_#PDTVid#" align="right" value="#PDTVcantidad#" onkeyup = "_CFinputText_onKeyUp(this,event,5,0,false);"); onblur="modificar(#PDTVid#, #form.PETid#, this, #session.usucodigo#)"' >
	<cfset temp = QuerySetCell(rsPDTVehiculos,'Carril',PDTVcarril,PDTVcarril)>
	<cfset temp = QuerySetCell(rsPDTVehiculos,'C_'&#PVid#,VR,PDTVcarril)>
	<cfset input&="I_#PDTVid#,">
</cfloop>
<form name="form2" action="" method="post">
	<cfoutput>
		<table width="100%">
			<tr>	
				<td>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
							query="#rsPDTVehiculos#"
							desplegar="#columnas#"
							etiquetas="#desplegar#"
							formatos="#formatos#"
							align="#align#"
							ira="registroMovimientos.cfc"
							showlink="false" incluyeform="false"
							form_method="post"
							showEmptyListMsg="yes"
							keys="#idC#"	
							MaxRows="50"
							/>		
				</td>
			</tr>
		</table>
		<iframe name="ifrCambioVal" id="ifrCambioVal" marginheight="0" marginwidth="10" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
	</cfoutput>
</form>
<iframe name="ifrCambioVal" id="ifrCambioVal" marginheight="0" marginwidth="10" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
<cfoutput>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="javascript1.2" type="text/javascript">

	function modificar(PDTVid, PETid, inp, MBUsucodigo){
			if(trim(inp.value).length < 1 )
				inp.value=0;
			document.getElementById('ifrCambioVal').src = 'registroMovimientos_SQL.cfm?PDTVid='+(PDTVid)+'&PETid='+PETid+'&PDTVcantidad='+(inp.value)+'&MBUsucodigo='+(MBUsucodigo);
	}
</script>
</cfoutput>