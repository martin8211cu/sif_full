<form name="lista" action="OCtransporte.cfm" method="post">
	<table align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
			<td class="tituloListas" align="left" valign="bottom">
					<strong >Estado</strong>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<cfparam name="form.filtroOCTestado" default="">
					<select name="filtroOCTestado">
						<option value="">(Todos los Estados)</option>
						<option value="1" <cfif form.filtroOCTestado EQ "1">selected</cfif>>Transportes Abiertos</option>
						<option value="2" <cfif form.filtroOCTestado EQ "2">selected</cfif>>Transportes ReAbiertos</option>
						<option value="3" <cfif form.filtroOCTestado EQ "3">selected</cfif>>Transportes Cerrados Manualmente</option>
						<option value="4" <cfif form.filtroOCTestado EQ "4">selected</cfif>>Transportes Cerrados</option>
						<option value="5" <cfif form.filtroOCTestado EQ "5">selected</cfif>>Transportes Sólo Para Transito</option>
						<option value="6" <cfif form.filtroOCTestado EQ "6">selected</cfif>>Transportes Cerrados Sólo Para Transito</option>
					</select>
			</td>
		</tr>
	</table>
	<cfif form.filtroOCTestado EQ "">
		<cfset LvarFiltroEstado = "">
	<cfelse>
		<cfset LvarFiltroEstado = " 
					AND 
					case
						when OCTestado	= 'A' AND OCTnumCierre=0 then 1
						when OCTestado	= 'A' AND OCTnumCierre>0 then 2
						when OCTestado	= 'C' AND OCTnumCierre=0 then 3
						when OCTestado	= 'C' AND OCTnumCierre>0 then 4
						when OCTestado	= 'T' then 5
						when OCTestado	= 'C' AND OCTnumCierre<0 then 6
					end = #form.filtroOCTestado# ">
	</cfif>
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
		filtro="Ecodigo = #Session.Ecodigo# #LvarFiltroEstado# order by Orden, OCTtipo, OCTtransporte"
		cortes="Estado,Tipo"
		desplegar="OCTtransporte,OCTvehiculo,OCTfechaPartida,OCTfechaLlegada"
		etiquetas="Transporte,Vehículo,Partida,Llegada"
		formatos="S,S,D,D"
		align="left,left,left,left"
		ira="OCtransporte.cfm"
		form_method="post"
		incluirForm="no"
		keys="OCTid"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		botones="Nuevo,Importar"
	/>
</form>