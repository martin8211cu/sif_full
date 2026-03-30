<title>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ConciliacionMasiva"
		Default="Conciliación Masiva"
		returnvariable="LB_ConciliacionMasiva"/>
		<cfoutput>#LB_ConciliacionMasiva#</cfoutput>
</title>	
<cf_templatecss>
<cf_web_portlet_start titulo="#LB_ConciliacionMasiva#">
<cfif isdefined("form.btnConciliar")>
	<cfquery name="rsMeses" datasource="#session.dsn#">
		select <cf_dbfunction name="to_number" args="VSvalor"> as value, VSdesc as description
		from VSidioma vs
			inner join Idiomas id
			on id.Iid = vs.Iid
			and id.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#">
			AND  <cf_dbfunction name="to_number" args="VSvalor">  =   <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATmes#">
		where VSgrupo = 1
		order by 1
	</cfquery>
	
	<cfquery name="rsConceptos" datasource="#session.dsn#">
		select Cconcepto as value, Cdescripcion as description, 0 as orden
		from ConceptoContableE
		where Ecodigo =  #session.Ecodigo# 
		AND Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">
		order by 3,2
	</cfquery>

	<!---*******************************************
	*****Valida que no hayan registros del**********
	*****documento por conciliar que tengan*********
	*****estado menor a 1 (Completo)****************
	********************************************--->
	<cfquery name="rsConciliar" datasource="#session.dsn#">
		select distinct a.Ecodigo,a.GATperiodo,a.GATmes,a.Edocumento,a.Cconcepto
		from GATransacciones a
		where a.Ecodigo = 	 #Session.Ecodigo# 
		and a.GATperiodo = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATperiodo#">
		and a.GATmes = 		<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.GATmes#">
		and a.Cconcepto =   <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">
		and a.GATestado = 1
		and a.Cconcepto is not null
		and a.Edocumento is not null
		and GATestado = 1
		and 
		not exists ( select 1 from GATransacciones b
					where a.Ecodigo = b.Ecodigo 
					and a.GATperiodo = b.GATperiodo
					and a.GATmes = b.GATmes
					and coalesce(a.Cconcepto,-1) = coalesce(b.Cconcepto,-1)
					and coalesce(a.Edocumento,-1) = coalesce(b.Edocumento,-1)
					and b.GATestado <> 1
					and a.GATestado = 1 
		)		
	</cfquery>
	<cf_dbtemp name="ConcMasiva_V1" returnvariable="CONCILIAR" datasource="#session.dsn#">
		<cf_dbtempcol name="IDcontable" 	type="numeric"	mandatory="yes">
		<cf_dbtempcol name="Ecodigo"  		type="numeric"  mandatory="yes">
		<cf_dbtempcol name="GATperiodo"  	type="numeric"  mandatory="yes">
		<cf_dbtempcol name="GATmes"  		type="numeric"  mandatory="yes">
		<cf_dbtempcol name="Cconcepto"  	type="numeric"  mandatory="yes">
		<cf_dbtempcol name="Ocodigo"  		type="numeric"  mandatory="yes">
		<cf_dbtempcol name="Odescripcion"  	type="varchar(100)"  mandatory="yes">
		<cf_dbtempcol name="Edocumento"  	type="numeric"  mandatory="yes">
		<cf_dbtempcol name="CFcuenta"  		type="numeric"  mandatory="yes">
		<cf_dbtempcol name="CFformato"  	type="varchar(100)"  mandatory="yes">
		<cf_dbtempcol name="MontoGestion"  	type="money"  	mandatory="yes">
		<cf_dbtempcol name="MontoAsiento"  	type="money"  	mandatory="yes">
		<cf_dbtempcol name="Conciliado"  	type="numeric"  mandatory="yes">
		<cf_dbtempkey cols="IDcontable,Ocodigo,CFcuenta">
	</cf_dbtemp>
	
	<form action="ConciliacionMasiva.cfm" method="post" name="form1">
		<table width="100%" border="0">
			<cfif rsConciliar.recordcount gt 0>
				<tr>
					<td colspan="2" align="right">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Regresar"
						Default="Regresar"
						returnvariable="BTN_Regresar"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Cerrar"
						Default="Cerrar"
						returnvariable="BTN_Cerrar"/>
						
						<input name="btnRegresarUP" type="submit" value="<cfoutput>#BTN_Regresar#</cfoutput>" tabindex="1">
						<input name="btnCerrarUP" type="button" value="<cfoutput>#BTN_Cerrar#</cfoutput>" onClick="javascript:cerrar();" tabindex="1">
					</td>
				</tr>
				<tr>
					<td colspan="2" >&nbsp;</td>
				</tr>
			</cfif>
			
			<tr>
				<td colspan="2" align="center"><strong>Resultado del proceso de conciliación masiva</strong></td>
			</tr>
			<tr>
				<td width="10%"><strong>Periodo:&nbsp;&nbsp;</strong></td>
				<td width="90%"><cfoutput>#Form.GATperiodo#</cfoutput></td>
			</tr>
			<tr>
				<td><strong>Mes:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#rsMeses.description#</cfoutput></td>
			</tr>
			<tr>
				<td><strong>Concepto:&nbsp;&nbsp;</strong></td>
				<td><cfoutput>#rsConceptos.description#</cfoutput></td>
			</tr>	
			<tr>
			<td colspan="2"><hr></td>
			</tr>		
		<cfif rsConciliar.recordcount lt 1>
			<tr>
				<td colspan="2"  align="center"><font color="##FF0000">No hay información que cumpla con estos filtros</font></td>
			</tr>
		</cfif>
		
		<cfloop query="rsConciliar">
			<cfset todobien = true>
			<cfset GATperiodo = rsConciliar.GATperiodo>
			<cfset GATmes = rsConciliar.GATmes>
			<cfset Cconcepto = rsConciliar.Cconcepto>
			<cfset Edocumento = rsConciliar.Edocumento>
			<tr>
			<td colspan="2" bgcolor="#CCCCCC"><strong>Documento</strong>: <cfoutput>#Edocumento#</cfoutput></td>
			</tr>	

			
			<cfquery name="rsValida1" datasource="#session.dsn#">
				select 1
				from GATransacciones a
				where a.Ecodigo =  #Session.Ecodigo# 
				and a.GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
				and a.GATmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
				and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
				and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">
				and a.GATestado < 1
			</cfquery>
			<cfif rsValida1.recordcount>
				<cfset todobien = false>
				<tr>
					<td colspan="2" >
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<font color="##FF0000">Error</font>.  Todas las cuentas de la Transacción deben encontrarse <br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					completas para conciliar la transacción</td>
				</tr>
			</cfif>
			<!---*******************************************
			*****Valida que todas las cuentas de las******** 
			*****transacciones estén en la tabla de*********
			*****Cuentas de Mayor de Gestion****************
			*****documento por conciliar que tengan*********
			********************************************--->
			<cfquery name="rsValida2A" datasource="#session.dsn#">
				select 1
				from GATransacciones a
				where a.Ecodigo =  #Session.Ecodigo# 
				and a.GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
				and a.GATmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
				and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
				and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">
			</cfquery>
			<cfquery name="rsValida2B" datasource="#session.dsn#">
				select 1
				from GATransacciones a
					inner join CFinanciera b
						inner join GACMayor c
							on c.Ecodigo=b.Ecodigo
							and c.Cmayor=b.Cmayor
						on b.Ecodigo=a.Ecodigo
						and b.CFcuenta=a.CFcuenta				
				where a.Ecodigo =  #Session.Ecodigo# 
				and a.GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
				and a.GATmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
				and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
				and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">
			</cfquery>
			<cfif rsValida2A.recordcount neq rsValida2B.recordcount>
				<cfset todobien = false>
				<tr>
				  <td colspan="2" >
				    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<font color="##FF0000">Error</font>. Existen cuentas en las transacciones que no son válidas <br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					para el proceso de Conciliación . <br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					Valide las cuentas con el catálogo de cuentas de mayor de gestión. </td>
				</tr>
			</cfif>
			<!---*******************************************
			*****Valida que todas las cuentas del Asiento***
			*****que esten en la tabla de Cuentas de Mayor**
			*****de Gestion estén en el conjunto de********* 
			*****Transacciones******************************
			********************************************--->
			<cfquery name="rsValida3A" datasource="#session.dsn#">
				select distinct a.Ccuenta
				from HDContables a
					inner join CContables b
						inner join GACMayor c
							on c.Ecodigo=b.Ecodigo
							and c.Cmayor=b.Cmayor
						on b.Ecodigo=a.Ecodigo
						and b.Ccuenta=a.Ccuenta		
				where a.Ecodigo =  #Session.Ecodigo# 
				and a.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
				and a.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
				and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
				and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">
			</cfquery>
			<cfquery name="rsValida3B" datasource="#session.dsn#">
				select distinct Ccuenta
				from GATransacciones a
					inner join CFinanciera b
						on b.Ecodigo=a.Ecodigo
						and b.CFcuenta=a.CFcuenta				
				where a.Ecodigo =  #Session.Ecodigo# 
				and a.GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
				and a.GATmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
				and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
				and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">
			</cfquery>
			<cfif rsValida3A.recordcount neq rsValida3B.recordcount>
				<cfset todobien = false>
				<tr>
				  <td colspan="2" >
				  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<font color="##FF0000">Error</font>. Existen cuentas en el asiento contable que deberían estar en las transacciones. <br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					Valide las cuentas con el catálogo de cuentas de mayor de gestión.</td>
				</tr>				
			</cfif>
			<!---*******************************************
			*****Inicia Proceso de Conciliacion*************
			*****no requiere transacción********************
			********************************************--->
			<cfif todobien>
				<cfquery name="rsHDContables" datasource="#Session.Dsn#">
					insert into #CONCILIAR#(IDcontable,
							Ecodigo,
							GATperiodo,
							GATmes,
							Cconcepto,
							Ocodigo,
							Odescripcion,
							Edocumento,
							CFcuenta,
							CFformato,
							MontoGestion,
							MontoAsiento,
							Conciliado)
					select 	a.IDcontable,
							a.Ecodigo,
							a.GATperiodo,
							a.GATmes,
							a.Cconcepto,
							a.Ocodigo,
							d.Odescripcion,
							a.Edocumento,
							a.CFcuenta,
							c.CFformato,
							coalesce(sum(a.GATmonto),0.00) as MontoGestion, 
							000000000.0000 as MontoAsiento,
							0 as Conciliado
					from GATransacciones a
					inner join CFinanciera c
						on c.CFcuenta = a.CFcuenta
						and	c.Ecodigo = a.Ecodigo
					inner join Oficinas d
						on d.Ecodigo = a.Ecodigo
						and d.Ocodigo = a.Ocodigo
					where a.Ecodigo =  #Session.Ecodigo# 
					and a.GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATperiodo#">
					and a.GATmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATmes#">
					and a.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
					and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">
					group by a.IDcontable,
							a.Ecodigo,
							a.GATperiodo,
							a.GATmes,
							a.Cconcepto,
							a.Ocodigo,
							d.Odescripcion,
							a.Edocumento,
							a.CFcuenta,
							c.CFformato
				</cfquery>
				<cfquery datasource="#Session.Dsn#">	
					update #CONCILIAR#
						set MontoAsiento = 
						(select coalesce(sum(b.Dlocal*(case b.Dmovimiento when 'D' then 1 else -1 end)),0.00)
						from HDContables b
						where  b.IDcontable = #CONCILIAR#.IDcontable
						and b.Ocodigo = #CONCILIAR#.Ocodigo
						and b.CFcuenta = #CONCILIAR#.CFcuenta
						)
				</cfquery>
				<cfquery datasource="#Session.Dsn#">		
					update #CONCILIAR#
					set Conciliado = 
					case when MontoAsiento = MontoGestion then 1 else 0 end
				</cfquery>
				<cfquery name="sinConciliar" datasource="#Session.Dsn#">		
						select count(1) as cantidad
						from #CONCILIAR#
						where Conciliado = 0
				</cfquery>
				<cfif sinConciliar.cantidad EQ 0>
					<cfquery datasource="#Session.Dsn#">	
						update GATransacciones
						set GATestado = 2
						where Ecodigo =  #Session.Ecodigo# 
						and GATperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATPeriodo#">
						and GATmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#GATMes#">
						and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Cconcepto#">
						and Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edocumento#">
					</cfquery>
				</cfif>
				<cfquery name="rsConciliado" datasource="#Session.Dsn#">
					select Conciliado from  #CONCILIAR# where Conciliado = 1
				</cfquery>
				<cfif rsConciliado.recordcount eq 0>
					<tr>
					  <td colspan="2" >
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<font color="##FF0000">Error</font>. El monto del asiento no es igual al monto gestionado.
					  </td> 
					</tr>
					<tr>
						<td colspan="2" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="##FF0000">Conciliación Cancelada!</font></td>
					</tr>
				<cfelse>
					<tr>
						<td colspan="2" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="##0000FF">Conciliación realizada con exito</font></td>
					</tr>	
				</cfif>
			<cfelse>
				<tr>
					<td colspan="2" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="##FF0000">Conciliación Cancelada!</font></td>
				</tr>
			</cfif>
			
			<cfquery name="rsHDContables" datasource="#Session.Dsn#">
				delete from #CONCILIAR#
			</cfquery>
		</cfloop>
		<!---*******************************************
		*****Termina Proceso de Conciliacion************
		********************************************--->
	</cfif>
	<tr>
		<td colspan="2" align="center">--- Ultima línea ---</td>
	</tr>	
	<tr>
		<td colspan="2" >&nbsp;</td>
	</tr>
	<tr>	
		<td colspan="2" align="right">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Regresar"
			Default="Regresar"
			returnvariable="BTN_Regresar"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Cerrar"
			Default="Cerrar"
			returnvariable="BTN_Cerrar"/>		
			<cfoutput>
				<input name="btnRegresarDOWN" type="submit" value="#BTN_Regresar#" tabindex="2">
				<input name="btnCerrarDOWN" type="button" value="#BTN_Cerrar#" onClick="javascript:cerrar();" tabindex="2">
			</cfoutput>
		</td>
	</tr>
	</table>
</form>
<script language="javascript" type="text/javascript">
	function cerrar(){
		window.close();
		window.opener.location.reload();
	}
</script>

<cf_web_portlet_end>
