<cfif isdefined("LvarCerrar")>
	<cfset LvarTipo = "Cerrar, Ver_Cierre">
	<cfset LvarEstado = " AND OCTestado	= 'A'">
<cfelse>
	<cfset LvarTipo = "Reabrir, Ver_Reapertura">
	<cfset LvarEstado = " AND OCTestado	= 'C'">
	<!---
		Se puede reabrir un Transporte si fue cerrado con el proceso de cierre
			Si OCTnumCierre > 0:	Cerrado con el proceso de cierre
			Si OCTnumCierre = 0:	Cerrado por el mantenimiento de Transportes
			Si OCTnumCierre < 0:	Cerrado por el mantenimiento de Transportes pero de Tránsito sin Órdenes Comerciales
	--->
	<cfset LvarEstado = LvarEstado & " AND OCTnumCierre>0">
</cfif>
<form name="lista" action="OCtransporte_sql.cfm" method="post">
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="OCtransporte"
		columnas="
					OCTid,
					case
						when OCTtipo = 'B' then 'Barcos'
						when OCTtipo = 'A' then 'Aviones'
						when OCTtipo = 'T' then 'Terrestres'
						when OCTtipo = 'F' then 'Ferrocarriles'
						when OCTtipo = 'O' then 'Otros Tipos'
					end as Tipo,
					OCTtransporte,OCTvehiculo,OCTfechaPartida,OCTfechaLlegada,
					case
						when OCTestado	= 'A' AND OCTnumCierre=0 then 'Transportes Abiertos'
						when OCTestado	= 'A' AND OCTnumCierre>0 then 'Transportes ReAbiertos'
						when OCTestado	= 'C' AND OCTnumCierre=0 then 'Transportes Cerrados Manualmente'
						when OCTestado	= 'C' AND OCTnumCierre>0 then 'Transportes Cerrados'
						when OCTestado	= 'T' then 'Sólo Para Transito (No se pueden usar en Órdenes Comerciales)'
						when OCTestado	= 'C' AND OCTnumCierre<0 then 'Transportes Cerrados Sólo Para Transito'
						else OCTestado
					end as Estado,
					case
						when OCTestado	= 'A' AND OCTnumCierre=0 then 1
						when OCTestado	= 'A' AND OCTnumCierre>0 then 2
						when OCTestado	= 'C' AND OCTnumCierre=0 then 3
						when OCTestado	= 'C' AND OCTnumCierre>0 then 4
						when OCTestado	= 'T' then 5
						when OCTestado	= 'C' AND OCTnumCierre<0 then 6
						else 7
					end as Orden
				"
		filtro="Ecodigo = #Session.Ecodigo# #LvarEstado# order by Orden, OCTtipo, OCTtransporte"
		cortes="Estado,Tipo"
		desplegar="OCTtransporte,OCTvehiculo,OCTfechaPartida,OCTfechaLlegada"
		etiquetas="Transporte,Vehículo,Partida,Llegada"
		formatos="S,S,D,D"
		align="left,left,left,left"
		showLink="no"
		incluirForm="no"
		keys="OCTid"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		botones="#LvarTipo#"
		checkboxes="S"
	/>
</form>
<script language="javascript">
	function funcCerrar()
	{
		return confirm("¿Desea cerrar el transporte y realizar los ajustes contables?\n\t- Trasladar los sobrantes de Transito al Costo \n\t- Devolver los faltantes de Transito del Costo");
	}
	function funcReabrir()
	{
		return confirm("¿Desea reabrir el transporte y reversar los Ajustes contables de sobrantes y faltantes de Transito");
	}
</script>