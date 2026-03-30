<!---
div#max {
max-height: 200px;
overflow: auto;
/* Los valores de abajo son solo para dejarlo mas coqueto :). */
width: 300px; background: #ccc;
border: 3px solid #666;
padding: 10px;
}
--->


<!---
<cfloop from="1" to="100" index="i">
	<cfquery datasource="minisif">
		insert into RHPlazaPresupuestaria( Ecodigo, RHPPcodigo, RHPPdescripcion, Mcodigo, BMfecha, BMUsucodigo)
		values( 1, '#RepeatString( 0, 4-len(i) )##i#', 'Plaza Presupuestaria #i#', 1, getdate(), 27 )
	</cfquery>
</cfloop>
--->

<!---
<cfinvoke component="sif.rh.Componentes.RH_AplicaMovimientoPlaza" method="insertarPlaza" returnvariable="id" > 
	<cfinvokeargument name="DSN" value="minisif">
	<cfinvokeargument name="Ecodigo" value="1">	
	<cfinvokeargument name="RHPPcodigo" value="0001">
	<cfinvokeargument name="RHPPdescripcion" value="Plaza Presupuestaria 0001">	
	<cfinvokeargument name="BMUsucodigo" value="27">		
	<cfinvokeargument name="RHPPfechav" value="">
	<cfinvokeargument name="Iseleccionable" value="">	
</cfinvoke>

<cfinvoke component="sif.rh.Componentes.RH_AplicaMovimientoPlaza" method="insertarMovimiento" returnvariable="idm" > 
	<cfinvokeargument name="RHPPid" value="#id#">
	<cfinvokeargument name="RHTMid" value="2">	
	<cfinvokeargument name="RHPPcodigo" 	 value="0003" >
	<cfinvokeargument name="RHPPdescripcion" value="La FOFA" >
	<cfinvokeargument name="RHMPfdesde" value="08/03/1975" >
	<cfinvokeargument name="RHMPfhasta" value="26/10/1979">
	<cfinvokeargument name="RHMPmonto"  value="1,250,253.58"> 
</cfinvoke>

<cfinvoke component="sif.rh.Componentes.RH_AplicaMovimientoPlaza" method="modificarMovimiento" > 
	<cfinvokeargument name="RHMPid" value="6">
	<cfinvokeargument name="RHTMid" value="2">	
	<cfinvokeargument name="RHPPcodigo" 	 value="000X" >
	<cfinvokeargument name="RHPPdescripcion" value="La FOFA XXX" >
	<cfinvokeargument name="RHMPfdesde" value="08/03/1985" >
	<cfinvokeargument name="RHMPfhasta" value="26/10/1989">
	<cfinvokeargument name="RHMPmonto"  value="2,000,000.00"> 
</cfinvoke>

<cfinvoke component="sif.rh.Componentes.RH_AplicaMovimientoPlaza" method="eliminarMovimiento" > 
	<cfinvokeargument name="RHMPid" value="6">
</cfinvoke>
--->


<!--- 
	<cfargument name="RHPPid" 			type="string" 	required="no" default=""> 
	<cfargument name="RHPPcodigo" 		type="string" 	required="no" default=""> 
	<cfargument name="RHPPdescripcion" 	type="string" 	required="no" default=""> 
	<cfargument name="RHMPPid" 			type="string" 	required="no" default=""> 
	<cfargument name="RHCid" 			type="string" 	required="no" default=""> 
	<cfargument name="RHTTid" 			type="string" 	required="no" default=""> 
	<cfargument name="RHMPestado" 		type="string" 	required="no" default="P"> 
	<cfargument name="RHMPnegociado" 	type="string" 	required="no" default="N"> 
	<cfargument name="RHMPmonto" 		type="string" 	required="no" default="0"> 
	<cfargument name="RHMPestadoplaza"	type="string" 	required="no" default="A"> 
	<cfargument name="id_tramite" 		type="string" 	required="no" default=""> 

	<cfargument name="CFidant" 			type="string" 	required="no" default=""> 
	<cfargument name="CFidnuevo" 		type="string" 	required="no" default=""> 
	<cfargument name="CFidcostoant" 	type="string" 	required="no" default=""> 
	<cfargument name="CFidcostonuevo" 	type="string" 	required="no" default=""> 
	
--->

	<!---
	<cfinvokeargument name="RHMPPid" value="">		
	--->
<!---

<body>

<form name="form1">
<table >
	<tr>
		<td>
			<select name="p" size="10" multiple>
				<option value="1">Item 1</option>
				<option value="2">Item 2</option>
				<option value="3">Item 3</option>
				<option value="4">Item 4</option>
				<option value="5">Item 5</option>								
			</select>
		</td>

		<TD>
			<input type="button" name="pasar" value=">>" onClick="javascript:f();" />
		</TD>

		<td>
			<select name="q" size="10" multiple>
				<option value="1">Item 1</option>
				<option value="2">Item 2</option>
				<option value="3">Item 3</option>
				<option value="4">Item 4</option>
				<option value="5">Item 5</option>								
			</select>
		</td>
	</tr>
</table>

<cf_sifcalendario form="form1" name="f" onblur="x" >

<input type="text" name="i" value="">
</form>

<script>
	
	var x = '';
	var y = x.split(','); 
	
	for ( var i=0; i<y.length; i++ ){
		//d.f['x'+i].value
		alert(y[i])
	}
</script>
--->

<cfset plazas = arraynew(1) >
<cfset plazas[1] = 'Analistas Programadores' >
<cfset plazas[2] = 'Director de Proyectos' >
<cfset plazas[3] = 'Gerentes Administrativos' >
<cfset plazas[4] = 'Mantenimiento a Instalaciones' >
<cfset plazas[5] = 'Programadores' >
<cfset plazas[6] = 'Contaduría' >
<cfset plazas[7] = 'Diseñador' >
<cfset plazas[8] = 'Documentador' >
<cfset plazas[9] = 'Gerencia de Ventas' >
<cfset plazas[10] = 'Mecánica y Repuestos' >
<cfset plazas[11] = 'Miscelaneos' >
<cfset plazas[12] = 'Analista Programador' >
<cfset plazas[13] = 'Responsable de Producto' >
<cfset plazas[14] = 'Secretarias/Recepcionistas' >
<cfset plazas[15] = 'Soporte' >
<cfset plazas[16] = 'Telecomunicaciones' >
<cfset plazas[17] = 'Ventas' >

<!---
	<cftransaction>

		<cfloop from="2000" to="2073" index="i">
			<cfquery datasource="minisif" name="pp" >
				insert minisif..RHPlazaPresupuestaria( Ecodigo, RHMPPid, RHPPcodigo, RHPPdescripcion, RHPPfechav, Mcodigo, BMfecha, BMUsucodigo)
				values ( 1, 24, 'PL#i#', 'Plaza Presupuestaria #i#', '20050101', 1, getdate(), 27  )
				select @@identity as id		
			</cfquery>

			<cfquery datasource="minisif" name="pp" >
				insert RHPlazas (Ecodigo, RHPpuesto, Dcodigo, Ocodigo, CFid, RHPPid, RHPdescripcion, RHPcodigo, RHPactiva, BMUsucodigo)
				values ( 1, 'ANP1', 1, 1 , 1, #pp.id#, 'Plaza #i#', 'P#i#', 1,  27 )
			</cfquery>

		</cfloop>

		<cfquery datasource="minisif" name="x">
			<!---select RHPPid, RHPPcodigo, RHPPdescripcion--->
			select count(1) as x
			from RHPlazaPresupuestaria
			where Ecodigo = 1
			and RHPPid > 183
			<!---order by 2 desc--->
		</cfquery>
		<cfdump var="#x#">


		<cfquery datasource="minisif" name="x">
			select RHPid, RHPcodigo, RHPdescripcion
			from RHPlazas
			where Ecodigo = 1
			and RHPPid > 20027
			order by 2 desc
		</cfquery>

		<cfquery name="emp" datasource="minisif">
			select LTid, DEid
			from LineaTiempo
			where getdate() between LTdesde and LThasta
			and Ecodigo = 1
			and DEid not in ( 4839, 4838 )
		</cfquery>
		<cfloop query="emp">
		
			<cfquery name="lt" datasource="minisif">
				select min(RHPid) as id
				from RHPlazas 
				where RHPid > 20027 
			  	and RHPid not in ( select RHPid from LineaTiempo where Ecodigo=1 )
			</cfquery>	  
		
			<cfif len(trim(lt.id))>
				<cfquery datasource="minisif" >
					update LineaTiempo
					set RHPid = #lt.id#
					where LTid = #emp.LTid#
				</cfquery>
			</cfif>
		</cfloop>

		<cfquery name="x" datasource="minisif">
			select LTid, DEid, RHPid from LineaTiempo where Ecodigo = 1
		</cfquery>
		<cfdump var="#x#">


	<!---<cftransaction action="rollback" />--->
	</cftransaction>
--->

<!---
<cftransaction>
<cfquery name="x" datasource="minisif" maxrows="2">
	insert minisif..RHLineaTiempoPlaza(Ecodigo, RHPPid, RHCid, RHMPPid, RHTTid, CFidautorizado, RHLTPfdesde, RHLTPfhasta, CFcentrocostoaut, RHMPestadoplaza, RHMPnegociado, RHLTPmonto, Mcodigo, BMfecha, BMUsucodigo)
	select 1, a.RHPPid, 18, a.RHMPPid, 1500000000000060, 1, '20010101', '61000101', 1, 'A', 'N', 0, 1, getdate(), 27
	from RHPlazaPresupuestaria a
	
	inner join RHPlazas p
	on p.RHPPid = a.RHPPid
	
	where a.Ecodigo = 1
	and a.RHPPid not in ( select RHPPid from RHLineaTiempoPlaza )
</cfquery>
<cfquery name="x" datasource="minisif">
	select * from RHLineaTiempoPlaza
	where RHLTPid > 159
</cfquery>
<cfdump var="#x#">

<cftransaction action="rollback" />
</cftransaction>
--->

<!---500000000026127--->

<!--- arreglar las plazas que ya existen --->
<!---
	<cftransaction>

		<cfset nuevos = '' >
		<cfloop from="2000" to="2073" index="i">
			<cfquery datasource="minisif" name="pp" >
				insert minisif..RHPlazaPresupuestaria( Ecodigo, RHMPPid, RHPPcodigo, RHPPdescripcion, RHPPfechav, Mcodigo, BMfecha, BMUsucodigo)
				values ( 1, 24, 'PL#i#', 'Plaza Presupuestaria #i#', '20050101', 1, getdate(), 27  )
				select @@identity as id		
			</cfquery>
			<cfset nuevos = nuevos & ',' & pp.id>

			<cfquery datasource="minisif" name="x" maxrows="1">
				select min(RHPid) as RHPid
				from RHPlazas
				where Ecodigo=1
				and RHPPid <=183
				and RHPid between 2 and 20027
			</cfquery>
				
			<cfif LEN(TRIM(x.RHPid)) >
				<cfquery datasource="minisif">
					update RHPlazas
					set RHPPid = #pp.id#
					where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#x.RHPid#">
				</cfquery>
				
				<cfquery name="x" datasource="minisif" maxrows="2">
					insert minisif..RHLineaTiempoPlaza(Ecodigo, RHPPid, RHCid, RHMPPid, RHTTid, CFidautorizado, RHLTPfdesde, RHLTPfhasta, CFcentrocostoaut, RHMPestadoplaza, RHMPnegociado, RHLTPmonto, Mcodigo, BMfecha, BMUsucodigo)
					values(1, #pp.id#, 18, 12, 1500000000000060, 1, '20010101', '61000101', 1, 'A', 'N', 0, 1, getdate(), 27)
				</cfquery>
			</cfif>

		</cfloop>
		
		<cfquery name="x" datasource="minisif">
			select RHPid, RHPPid
			from RHPlazas
				where Ecodigo=1
				and RHPid between 2 and 20027
		</cfquery>
		<cfdump var="#x#">
--->		


<!---
		<cfquery datasource="minisif" name="x">
			select RHPid, RHPPid
			from RHPlazas
			where Ecodigo=1
			and RHPPid <=183
			and RHPid between 2 and 20027
		</cfquery>
		<cfdump var="#x#">

		<cfquery name="emp" datasource="minisif">
			select LTid, DEid
			from LineaTiempo
			where getdate() between LTdesde and LThasta
			and Ecodigo = 1
			and DEid not in ( 4839, 4838 )
		</cfquery>
		<cfloop query="emp">
		
			<cfquery name="lt" datasource="minisif">
				select min(RHPid) as id
				from RHPlazas 
				where RHPid > 20027 
			  	and RHPid not in ( select RHPid from LineaTiempo where Ecodigo=1 )
			</cfquery>	  
		
			<cfif len(trim(lt.id))>
				<cfquery datasource="minisif" >
					update LineaTiempo
					set RHPid = #lt.id#
					where LTid = #emp.LTid#
				</cfquery>
			</cfif>
		</cfloop>

		<cfquery name="x" datasource="minisif">
			select LTid, DEid, RHPid from LineaTiempo where Ecodigo = 1
		</cfquery>
		<cfdump var="#x#">
--->		


	<!---<cftransaction action="rollback" />--->
<!---	</cftransaction>--->

<!---
<cftransaction>
<cfquery name="x" datasource="minisif">
	select count(1)
	from RHCLTPlaza
	where Ecodigo = 1
</cfquery>
<cfdump var="#x#">


<cfquery name="x" datasource="minisif">
	select RHLTPid
	from RHLineaTiempoPlaza a
	where RHLTPid not in ( select RHLTPid from RHCLTPlaza )
</cfquery>

<cfset i = 1 >
<cfloop query="x">
	<cfset montillo = RandRange(125000, 600000) >

	<cfquery datasource="minisif">
		insert RHCLTPlaza ( RHLTPid, CSid, Ecodigo, Cantidad, Monto, CFformato, BMfecha, BMUsucodigo )
		values( #x.RHLTPid#, 5, 1, 0, #montillo#, null, getdate(), 27 )
	</cfquery>
	
	<cfset ins = RandRange(125000, 600000) >
	<cfif i mod 2 >
		<cfset montillo2 = RandRange(12500, 100000) >	
		<cfquery datasource="minisif">
			insert RHCLTPlaza ( RHLTPid, CSid, Ecodigo, Cantidad, Monto, CFformato, BMfecha, BMUsucodigo )
			values( #x.RHLTPid#, 6, 1, 0, #montillo2#, null, getdate(), 27 )
		</cfquery>
	</cfif>

	<cfset ins = RandRange(4000, 9000) >
	<cfif i mod 6 >
		<cfset montillo2 = RandRange(12500, 100000) >	
		<cfquery datasource="minisif">
			insert RHCLTPlaza ( RHLTPid, CSid, Ecodigo, Cantidad, Monto, CFformato, BMfecha, BMUsucodigo )
			values( #x.RHLTPid#, 9, 1, 0, #montillo2#, null, getdate(), 27 )
		</cfquery>
	</cfif>



	<cfset i = i + 1 >
</cfloop>

<cfquery name="x" datasource="minisif">
	select count(1)
	from RHCLTPlaza
	where Ecodigo = 1
</cfquery>
<cfdump var="#x#">

</cftransaction>
--->