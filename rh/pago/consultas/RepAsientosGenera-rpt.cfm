<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/sif/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>


<cfif isdefined("url.RCNid") and Len(Trim(url.RCNid))>
	
	<cfparam name="form.RCNid" default="#url.RCNid#">
	
	<cfquery datasource="#session.dsn#" name="rsCFInac">
		select distinct b.CFid, b.CFcodigo, b.CFdescripcion, b.CFcuentac
			from CFuncional b
				inner join RCuentasTipo a
					on b.CFid = a.CFid
					and a.RCNid = #url.RCNid#
			where b.Ecodigo = #session.Ecodigo#
				and b.CFestado = 0
	</cfquery>
	<cfif isdefined("rsCFInac") and rsCFInac.RecordCount GT 0>
		<!---CarolRS. Caso en que existan registros en cf inactivos en RCuentasTipo--->
		<cfinclude template="/rh/pago/consultas/CFuncional-Act.cfm">
	<cfelse>
		
		<!---CarolRS. Podria suceder que se de el caso de que se haya generado un asiento para exactus en un momento en 
		que uno de los centros funcionales en RCuentasTipo estubo inactivo por lo que se genero una propuesta en su momento, 
		pero podria ser que mas adelante el cliente decidiera activar el centro funcional que estubo inactivo, y despues otro 
		usuario genere de nuevo el asiento de exactus para esa nomina, desconociendo que en algun momento el asiento se habia 
		generado con una propuesta debido a que en su momento uno de los centros funcionales estaba inactivo. En este caso 
		se debe preguntar si desea generar los asientos con la situacion actual, o generar el asiento con la situacion propuesta
		anterior. --->
		
		<!--- Existen propuestas realizadas en algun momento anteriormente cuando algun centro funcional estaba inactivo?--->
		<!---Si existen registros propuestos debe de haber una alerta que indique 
		si se desea se procesar el registro con los centros funcionales propuestos 
		o con el centro funcional activo--->
		<cfquery datasource="#session.dsn#" name="DelRCTExac">
			delete from RCuentasTipoExactus
			where RCNid = #form.RCNid#
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		
			<!---CarolRS. Caso en que NO existen registros en cf inactivos en RCuentasTipo--->
			<!--- Agrega los registros que no esten a la tabla de RCuentasTipoExactus para la nomina y centros funcionales que corresponda --->
			<cfquery datasource="#session.dsn#" name="rsCFidAnt">
				insert into RCuentasTipoExactus(T.RCTid, T.RCNid, T.Ecodigo, T.tiporeg, T.DEid, T.referencia, T.cuenta, T.valor, T.Cformato, T.Ccuenta, T.CFcuenta, T.tipo, T.CFid, T.Ocodigo, T.Dcodigo, T.montores, T.vpresupuesto, T.BMfechaalta, T.BMUsucodigo, T.RHPPid, T.Periodo, T.Mes, T.valor2, T.CFidAnt, T.valorAnt)
				select distinct T.RCTid, T.RCNid, T.Ecodigo, T.tiporeg, T.DEid, T.referencia, T.cuenta, T.valor, T.Cformato, T.Ccuenta,
				 T.CFcuenta, T.tipo, T.CFid, T.Ocodigo, T.Dcodigo, T.montores, T.vpresupuesto, #now()#, T.BMUsucodigo, 
				 T.RHPPid, T.Periodo, T.Mes, T.valor2,  T.CFidAnt, T.valorAnt 
				
				from RCuentasTipo T
				where T.RCNid = #form.RCNid#					
				and T.Ecodigo = #session.Ecodigo#
				
			</cfquery>

		<!---LLamado a la generacion de asientos de exactus, con elctura en la tabla RCuentasTipoExactus--->
		<cfinclude template="/rh/pago/consultas/Genera_asiento.cfm">
	</cfif>
</cfif>

