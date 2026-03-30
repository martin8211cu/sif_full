<!--- /
******************************************
CARGA INICIAL DE HRCALCULONOMINA
	FECHA    DE    CREACIÓN:    19/03/2007
	CREADO   POR:   DORIAN   ABARCA  GÓMEZ
******************************************
*********************************
Archivo   de  generaración  final
Este   archivo   requiere es para 
realizar  la  copia  final  de la 
tabla temporal a la tabla real.
*********************************
--->
<cfquery datasource="#Gvar.Conexion#">
	insert into HRCalculoNomina
        (RCNid, Ecodigo, Usucodigo, Ulocalizacion, Tcodigo, 
         RCDescripcion, RCdesde, RChasta, RCestado)

	select 
       b.CPid, #Gvar.Ecodigo#, #session.Usucodigo#, '00', b.Tcodigo, 
       a.CDRHHRCdescripcion, CDRHHRCfdesde, CDRHHRCfhasta, 3                    
	from CDRHHRCalculoNomina a
		inner join CalendarioPagos b
		on b.CPdesde   = a.CDRHHRCfdesde and 
       	b.CPhasta   = a.CDRHHRCfhasta and 
		b.Tcodigo  = a.CDRHHRCnomina and 
		a.Ecodigo = b.Ecodigo 
	where a.Ecodigo = #Gvar.Ecodigo#
	and CDPcontrolv = 1
	and CDPcontrolg = 0
</cfquery>
<!--- LZ 2009-11-23, Se Marcan los Calendarios de Pago asociados como Calculados, para que no aparezca al crear Relaciones Nuevas. --->

<cfquery datasource="#Gvar.Conexion#">
		update CalendarioPagos
		set CPfcalculo=CPhasta,
			CPfenvio = CPhasta
		Where CPid in (Select RCNid from HRCalculoNomina)
		and Ecodigo = #Gvar.Ecodigo#
		and CPfcalculo is null
</cfquery>