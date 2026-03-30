<!---                                  Agregar                                           --->
<cfif isdefined ('form.Agregar')>

		<cfif isdefined("form.NumLote")>
        	   <cfif isdefined("form.num") and not len(trim(form.num))>
                  <cf_ErrorCode code="-1" msg="No se indico un numero de deposito y el dato no puede quedar en blanco. Proceso cancelado.">
             </cfif>

             <cfif isdefined('form.CBid') and len(trim(form.CBid))>
                <cfquery name="rsMonedaDeCuentaBancos" datasource="#session.dsn#">
                 select Mcodigo
                  from CuentasBancos
                 where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
                </cfquery>
                <cfif not len(trim(rsMonedaDeCuentaBancos.Mcodigo))>
                   <cf_ErrorCode code="-1" msg="No se pudo obtener el tipo de moneda para la cuenta bancaria, por favor intente nuevamente.">
                </cfif>
             <cfelse>
                  <cf_ErrorCode code="-1" msg="El dato de la cuenta bancaria no se ha podido obtener, por favor intente nuevamente.">
             </cfif>
             <!--- Valido si la moneda de la cuenta y la moneda de la remesa son iguales, de lo contrario no deberia dejar registrar la remesa --->
             <cfif trim(form.Mcodigo) neq  trim(rsMonedaDeCuentaBancos.Mcodigo)>
                <!---- Obtengo la Moneda del formulario  para presentar en el mensaje de error ---->
                <cfquery name="rsMonedaForm" datasource="#session.dsn#">
                   select Mnombre
                     from Monedas
                 where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
                   and Ecodigo = #session.Ecodigo#
                </cfquery>
                <!---- Obtengo la Moneda de la cuenta seleccionada, para presentar en el mensaje de error ---->
                <cfquery name="rsMonedaCuenta" datasource="#session.dsn#">
                   select Mnombre
                     from Monedas
                 where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedaDeCuentaBancos.Mcodigo#">
                   and Ecodigo = #session.Ecodigo#
                </cfquery>
                   form.Mcodigo
                <cf_ErrorCode code="-1" msg="La moneda de la cuenta bancaria: #rsMonedaCuenta.Mnombre# y la moneda escogida para la remesa: #rsMonedaForm.Mcodigo#,  no son iguales, por favor escoja nuevamente la cuenta.">
             </cfif>

        <cfquery name="rsSQL" datasource="#session.dsn#">
			insert into ERemesas(
				FCid,
                Bid,
				CBid,
				NumDeposito,
				MntEfectivo,
				MntCheque,
				Mcodigo,
				Fremesa,
				Usucodigo,
                FACid,
                REstado,
                RLiquidacion,
                RNumLote,
                Falta
				)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Caja#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Bid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CBid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"	value="#num#">,
				0,
				0,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Mcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_date" 		value="#Now()#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
				null,
                <cfqueryparam cfsqltype="cf_sql_varchar"	value="E">,
                <cfqueryparam cfsqltype="cf_sql_varchar"	value="S">,
                <cfqueryparam cfsqltype="cf_sql_varchar"	value="#form.NumLote#">,
				<cfqueryparam cfsqltype="cf_sql_date" 		value="#Now()#">
			)
		</cfquery>

        <cfelse>

              <cfif isdefined("form.num") and not len(trim(form.num))>
                  <cf_ErrorCode code="-1" msg="No se indico un numero de deposito y el dato no puede quedar en blanco. Proceso cancelado.">
               </cfif>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into ERemesas(
				FCid,
                Bid,
				CBid,
				NumDeposito,
				MntEfectivo,
				MntCheque,
				Mcodigo,
				Fremesa,
				Usucodigo,
                FACid,
                REstado,
                RLiquidacion,
                Falta
				)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Caja#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Bid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CBid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"	value="#num#">,
				0,
				0,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Mcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_date" 		value="#Now()#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
				null,
                <cfqueryparam cfsqltype="cf_sql_varchar"	value="E">,
                <cfqueryparam cfsqltype="cf_sql_varchar"	value="N">,
				<cfqueryparam cfsqltype="cf_sql_date" 		value="#Now()#">
			)
		</cfquery>

        </cfif>


         <cfquery name="rsMaxNum" datasource="#session.dsn#">
			select coalesce(MAX(ERid),0) as numero from  ERemesas
		</cfquery>


<!---  <cfoutput>
        <form name="form1" action="InclusionRemesas.cfm" method="post">
	<table width="100%" align="center" border="0">
    <tr>
    <td>
       <input type="hidden" name="ERid" id="ERid" value="#rsMaxNum.numero#" />
    </td>
    </tr>
    </table>
    </form>

     <script language="javascript" type="text/javascript">
                     location.href='InclusionRemesas.cfm?ERid='+document.getElementById("ERid").value
	 </script>
   </cfoutput>--->

	  <cfif isdefined ("form.NumLote")>
          	<cflocation url="InclusionRemesas.cfm?NumLote=#form.NumLote#&ERid=#rsMaxNum.numero#">
       <cfelse>
          <cflocation url="InclusionRemesas.cfm?ERid=#rsMaxNum.numero#">
      </cfif>


</cfif>

<!---                                  Regresar                                           --->
<cfif isdefined ('form.Regresar')>

	  <cfif isdefined ("form.NumLote")>
          	<cflocation url="InclusionRemesas.cfm?NumLote=#form.NumLote#">
       <cfelse>
           <cflocation url="InclusionRemesas.cfm">
      </cfif>

</cfif>

<!---                                  Limpiar                                           --->
<cfif isdefined ('form.Limpiar')>
	<cflocation url="InclusionRemesas.cfm?Nuevo=nuevo">
</cfif>

<!---                                  Borrar Linea2                                      --->
<cfif isdefined ('form.btnElimina')>
	  <cfset LvarTabla ="HPagos">
		  <cfif isdefined ("form.NumLote")>
             <cfset LvarTabla ="Pagos">
          </cfif>


	<cfif not isdefined ('form.eli') or len(trim(form.eli)) eq 0>
		<cf_errorCode	code = "51701" msg = "No se escogio ninguna liquidación">
	</cfif>
	<cfloop list="#form.eli#" delimiters="," index="Lvar">
		  <cfset LvarTipo=#listgetat(Lvar, 1, '|')#>
	      <cfset LvarCheque=#listgetat(Lvar, 2, '|')#>
           <cfif LvarTipo eq '1'>
           		 <cfquery name="rsUpdatePF" datasource="#session.dsn#">
                     	update	FPagos
                     	set ERid = NULL
                   		where FPdocnumero = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarCheque#">
                </cfquery>
      		  <cfelse>
                <cfquery name="rsUpdatePF" datasource="#session.dsn#">
                         update	PFPagos
                         set ERid = NULL
                         where FPdocnumero = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarCheque#">
                </cfquery>
       </cfif>
       		    <cfquery name="delRem" datasource="#session.dsn#">
                         delete	from DRemesas
                         where NumChk = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarCheque#">
                </cfquery>
	</cfloop>

	      <cfset updateMonto(#form.ERid#, #form.Mcodigo#, #LvarTabla#)>

            <cfif isdefined ("form.NumLote")>
          		<cflocation url="InclusionRemesas.cfm?NumLote=#form.NumLote#&ERid=#form.ERid#">
     		  <cfelse>
         	   <cflocation url="InclusionRemesas.cfm?ERid=#form.ERid#">
     	  </cfif>
    <!---   <cfoutput>
     <cfset LvarERid = #form.ERid#>
        <form name="form3" action="InclusionRemesas.cfm" method="post">
            <table width="100%" align="center" border="0">
            <tr>
            <td>
               <input type="hidden" name="ERid" id="ERid" value="#LvarERid#" />
            </td>
            </tr>
            </table>
            </form>

     		<script language="javascript" type="text/javascript">
					document.form3.submit();
            </script>
       </cfoutput>	--->


</cfif>

<!---                                  Agregar Linea2                                      --->
 <cfif isdefined ('form.btnAgrega')>
    <cfset LvarTabla ="HPagos">
		  <cfif isdefined ("form.NumLote")>
             <cfset LvarTabla ="Pagos">
          </cfif>


	<cfif not isdefined ('form.agr') or len(trim(form.agr)) eq 0>
		<cf_errorCode	code = "51701" msg = "No se escogio ningun cheque">
	</cfif>
		<cfloop list="#form.agr#" delimiters="," index="Lvar">

          <cfset LvarTipo=#listgetat(Lvar, 1, '|')#>
          <cfset LvarCheque=#listgetat(Lvar, 2, '|')#>
          <cfif LvarTipo eq '1'>
			<cfset LvarFact=#listgetat(Lvar, 3, '|')#>
         <cfelse>
			<cfset LvarCCTcodigo=#listgetat(Lvar, 3, '|')#>
            <cfset LvarPcodigo =#listgetat(Lvar, 4, '|')#>
         </cfif>



         <cfif LvarTipo eq '1'>   <!---Es una factura--->
         <!---Se actuliza el campo de ERid de la tabla de facturas--->
		<cfquery name="rsUpdateFP" datasource="#session.dsn#">
			 update	FPagos
             set ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
           where FPdocnumero = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarCheque#">
           and Tipo = 'C'
		</cfquery>
          <!---Consulta necesaria para insert de las facturas  --->
           <cfquery name="rsFacturas" datasource="#session.dsn#">
         select     'Cheques'  as Origen,
                FPdocnumero as Cheque,
                FPmontoori  as MontoCheque,
                m.Msimbolo,
                m.Miso4217,
                m.Mcodigo,
                FPlinea,
                '1' as Dtipo,
                a.ETnumero,
                a.FCid,
                null as CCTcodigo, null as Pcodigo
            from FPagos a
            inner join Monedas m
              on  a.Mcodigo = m.Mcodigo
            inner join ETransacciones et
                on a.ETnumero = et.ETnumero
                and a.FCid = et.FCid
           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Mcodigo#">
              and et.FACid IS NULL
            <cfif isdefined("form.NumLote")>
            and et.ETestado = 'T'
            <cfelse>
            and et.ETestado = 'C'
              and et.FCid = #session.Caja#
            </cfif>
              and a.Tipo = 'C'
              and a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
              and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarFact#">
              <cfif isdefined ("form.NumLote")>
              and et.ETlote =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumLote#">
              </cfif>
         </cfquery>
         <!--- <cf_dbtimestamp
					datasource="#session.dsn#"
					table="DRemesas"
					timestamp="#ts_rversion#"
					field1="ERid,numeric,#form.ERid# "
					>--->
         <!---Inserta en la tabla de remesas --->
        <cfquery name="rsInsertF" datasource="#session.dsn#">
			insert into DRemesas(
				ERid,
                Dtipo,
                ETnumero,
                FCid,
				CCTcodigo,
				Pcodigo,
				NumChk,
				Monto,
                Ecodigo
				)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.ERid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarTipo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarFact#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"	value="#session.Caja#">,
                null,
                null,
				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarCheque#">,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#rsFacturas.MontoCheque#">,
                <cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
			)
		</cfquery>

        <cfelse>  <!---Es un recibo--->



        <!---Update del campo id de la remesa en la tabla de recibos--->
        	<cfquery name="rsUpdatePFP" datasource="#session.dsn#">
			 update	PFPagos
             set ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
           where  FPdocnumero = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarCheque#">
             and Tipo = 'C'
		</cfquery>
        <!---Consulta necesaria para datos para el insert de recibos en remesas--->

        	<cfquery name="rsRecibos" datasource="#session.dsn#">
              select  'Cheques' as Origen ,
                FPdocnumero as Cheque,
                FPmontoori  as MontoCheque,
                m.Msimbolo,
                m.Miso4217,
                m.Mcodigo,
                FPlinea,
                '2' as Dtipo,
                null as ETnumero, null as FCid,
                a.CCTcodigo,
                a.Pcodigo
          from PFPagos a
            inner join #LvarTabla# p
                on a.CCTcodigo = p.CCTcodigo
                and a.Pcodigo = p.Pcodigo
            inner join Monedas m
                on a.Mcodigo = m.Mcodigo

           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Mcodigo#">
             and a.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char" 	value="#LvarCCTcodigo#">
             and a.Pcodigo =  <cfqueryparam cfsqltype="cf_sql_char" 	value="#LvarPcodigo#">
             and p.FACid IS NULL
            <cfif isdefined("form.NumLote")>
            <cfelse>
             and p.FCid = #session.Caja#
            </cfif>
             and a.Tipo = 'C'
             and a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
             <cfif isdefined ("form.NumLote")>
             and p.Plote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumLote#">
             </cfif>
            </cfquery>
            <!---Insert en el detalle de remesas del recibo--->

            	<!--- <cf_dbtimestamp
					datasource="#session.dsn#"
					table="DRemesas"
					timestamp="#ts_rversion#"
					field1="ERid,numeric,#form.ERid# "
					>--->

             <cfquery name="rsInsertR" datasource="#session.dsn#">
			insert into DRemesas(
				ERid,
                Dtipo,
                ETnumero,
                FCid,
				CCTcodigo,
				Pcodigo,
				NumChk,
				Monto,
                Ecodigo
				)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.ERid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarTipo#">,
                null,
				null,
                <cfqueryparam cfsqltype="cf_sql_char" 	value="#LvarCCTcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_char" 	value="#LvarPcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarCheque#">,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#rsRecibos.MontoCheque#">,
                <cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
			)
		</cfquery>


        </cfif>
	</cfloop>
		 <cfset updateMonto(#form.ERid#, #form.Mcodigo#, #LvarTabla#)>
            <cfif isdefined ("form.NumLote")>
          		<cflocation url="InclusionRemesas.cfm?NumLote=#form.NumLote#&ERid=#form.ERid#">
     		  <cfelse>
         	   <cflocation url="InclusionRemesas.cfm?ERid=#form.ERid#">
     	  </cfif>
<!--- <cfoutput>
      <cfset LvarERid = #form.ERid#>
        <form name="form2" action="InclusionRemesas.cfm" method="post">
            <table width="100%" align="center" border="0">
            <tr>
            <td>
               <input type="hidden" name="ERid" id="ERid" value="#LvarERid#" />
            </td>
            </tr>
            </table>
   		 </form>

     		<script language="javascript" type="text/javascript">
					document.form2.submit();
            </script>
       </cfoutput>	--->
</cfif>

<!---                                  Nuevo                                            --->
<cfif isdefined ('form.Nuevo')>
	<cflocation url="InclusionRemesas.cfm?Nuevo=Nuevo">
</cfif>


<!---                                  Eliminar                                          --->
<cfif isdefined ('form.Eliminar')>
	<cfset LvarTabla ="HPagos">
		  <cfif isdefined ("form.NumLote")>
             <cfset LvarTabla ="Pagos">
          </cfif>


	<cfquery name="rsSQL" datasource="#session.dsn#">

select     'Cheques'  as Origen,
                FPdocnumero as Cheque,
                FPmontoori  as MontoCheque,
                m.Msimbolo,
                m.Miso4217,
                m.Mcodigo,
                FPlinea,
                '1' as Dtipo,
                a.ETnumero,
                a.FCid,
                null, null
            from FPagos a
            inner join Monedas m
              on  a.Mcodigo = m.Mcodigo
            inner join ETransacciones et
                on a.ETnumero = et.ETnumero
                and a.FCid = et.FCid
           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Mcodigo#">
              and et.FACid IS NULL

              <cfif isdefined("form.NumLote")>
               and et.ETestado = 'T'
              <cfelse>
              and et.FCid = #session.Caja#
               and et.ETestado = 'C'
              </cfif>
              and a.Tipo = 'C'
              and a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
              <cfif isdefined ("form.NumLote")>
              and et.ETlote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumLote#">
              </cfif>
        union all
        select  'Cheques' as Origen ,
                FPdocnumero as Cheque,
                FPmontoori  as MontoCheque,
                m.Msimbolo,
                m.Miso4217,
                m.Mcodigo,
                FPlinea,
                '2' as Dtipo,
                null, null,
                a.CCTcodigo,
                a.Pcodigo
          from PFPagos a
            inner join #LvarTabla# p
                on a.CCTcodigo = p.CCTcodigo
                and a.Pcodigo = p.Pcodigo
            inner join Monedas m
                on a.Mcodigo = m.Mcodigo
           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Mcodigo#">
             and p.FACid IS NULL
             <cfif isdefined("form.NumLote")>
             <cfelse>
             and p.FCid = #session.Caja#
             </cfif>
             and a.Tipo = 'C'
             and a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
			 <cfif isdefined ("form.NumLote")>
             and p.Plote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumLote#">
             </cfif>
</cfquery>

	<cfif rsSQL.recordcount gt 0><!---Si hay cheques incluidos en la remesa--->
    <!---Se eliminan las lineas incluidos en la remesa y vuelven a estar nulos--->
    <cfloop query="rsSQL">
       <cfif Dtipo eq '1'>
		  <cfquery name="rsUpdatePF" datasource="#session.dsn#">
			 update	FPagos
             set ERid = null
           where FPdocnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.Cheque#">
		</cfquery>
        <cfelse>
        	<cfquery name="rsUpdatePF" datasource="#session.dsn#">
                 update	PFPagos
                 set ERid = null
               where FPdocnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.Cheque#">
			</cfquery>
        </cfif>
            <cfquery name="delRem" datasource="#session.dsn#">
                         delete	from DRemesas
                         where NumChk = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsSQL.Cheque#">
                </cfquery>
   </cfloop>
   </cfif>

   			<cfquery name="delDremesa" datasource="#session.dsn#">
                delete from ERemesas
               where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.ERid#">
			</cfquery>
   <!---Aqui deberia hacer algun update para algun monto!!!--->
    <!---<cfset updateMonto(#form.ERid#, #form.Mcodigo#)> --->

     <cfif isdefined ("form.NumLote")>
          	<cflocation url="InclusionRemesas.cfm?NumLote=#form.NumLote#">
       <cfelse>
          <cflocation url="InclusionRemesas.cfm">
      </cfif>
</cfif>

<!---                                  Modificar                                          --->
<cfif isdefined ('form.Modificar')>


<cfquery datasource="#session.dsn#">
		update ERemesas
        set MntEfectivo= <cf_jdbcquery_param value="#replace(form.Mefectivo,',','','all')#" cfsqltype="cf_sql_money">
		where ERid =<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.ERid#">
	</cfquery>

       <cfif isdefined ("form.NumLote")>
          		<cflocation url="InclusionRemesas.cfm?NumLote=#form.NumLote#&ERid=#form.ERid#">
     		  <cfelse>
         	   <cflocation url="InclusionRemesas.cfm?ERid=#form.ERid#">
     	  </cfif>
    <!---
    <cfoutput>
      <cfset LvarERid = #form.ERid#>
        <form name="form6" action="InclusionRemesas.cfm" method="post">
            <table width="100%" align="center" border="0">
            <tr>
            <td>
               <input type="hidden" name="ERid" id="ERid" value="#LvarERid#" />
            </td>
            </tr>
            </table>
   		 </form>

     		<script language="javascript" type="text/javascript">
					document.form6.submit();
            </script>
       </cfoutput>	 --->



</cfif>

<!---                                Generar                                           --->
<cfif isdefined ('form.Generar')>

		<!---Parametros CFid--->
        <cfquery name="rsParam" datasource="#Session.DSN#">
            select  Pvalor
            from Parametros
            where Pcodigo = 16309
              and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif rsParam.recordcount eq 0 or (isdefined('rsParam') and not len(trim(rsParam.Pvalor)))>
	 	      <cf_ErrorCode code="-1" msg="No se ha definido un Centro funcional para Remesas. Favor configurar en el catalogo de parametros adicionales.">
	    </cfif>

<!---Se extrae el BTid--->
        <cfquery name="rsValores" datasource="#session.DSN#">
                select  BTid
                from CuentasPorMoneda
                where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.Mcodigo#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">
        </cfquery>
        <cfif rsValores.recordcount eq 0>
            <cf_ErrorCode code="-1" msg="No se ha definido una cuenta bancaria en la moneda de la remesa que desea generar. Verifique para continuar.">
        </cfif>

        <cfquery name="rsCF" datasource="#session.DSN#">
          select CFid,Dcodigo, Ocodigo
          from CFuncional
          where CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsParam.Pvalor#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"    value="#Session.Ecodigo#">
        </cfquery>
        <cfif not rsCF.recordcount>
         <cf_ErrorCode code="-1" msg="No se pudo obtener el centro funcional con el codigo:#rsParam.Pvalor# en la empresa:#Session.Ecodigo#, Verificar que el centro funcional para remesas esta debidamente configurado en parametros adicionales.">
       </cfif>

        <cfquery name="rsInfo" datasource="#session.dsn#">
 	select FCid,
                e.Bid,
				e.CBid,
				e.NumDeposito,
				e.MntEfectivo,
				e.MntCheque,
				e.Mcodigo as Mcodigo,
				e.Fremesa,
                e.FACid,
                e.ERid,
                Miso4217,
				case REstado
					when 'E'  then 'En Preparacion'
				end as estado
			from ERemesas e
             left join Monedas m on m.Mcodigo = e.Mcodigo
		where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
	</cfquery>

        <!---Oficina--->

       <cfquery name="rsOficina" datasource="#session.DSN#">
        select max(Ocodigo) as Ocodigo from ETransacciones where FCid = #session.Caja#
        </cfquery>

        <!---Tipo de cambio--->

        <cfquery name="TC" datasource="#session.dsn#">
         select Mcodigo, TCcompra, TCventa
         from Htipocambio
         where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
         and  Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
         and  Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
         and Mcodigo=#form.Mcodigo#
        </cfquery>
        <cfquery datasource="#Session.DSN#" name="rsEmpresa">
         select Miso4217
         from Empresas e
         inner join Monedas m
         on m.Mcodigo = e.Mcodigo
         where e.Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset LvarMiso4217LOC = rsEmpresa.Miso4217>
			<cfif rsInfo.Miso4217 EQ LvarMiso4217LOC>
                 <cfset LvarTC = "1.0000">
            <cfelse>
                 <cfset LvarTC = #TC.TCventa#>
           </cfif>



    <cfquery name="rsCajas" datasource="#Session.DSN#">
		select
			convert(varchar,a.FCid) as FCid, a.FCcodigo,a.FCcodigoAlt, a.FCdesc, a.FCalmmodif, convert(varchar,a.Aid) as Aid,
			convert(varchar,a.Ccuenta) as Ccuenta, b.Cdescripcion, b.Cformato, a.FCcomplemento,
			convert(varchar,a.Ccuentadesc) as Ccuentadesc, c.Cdescripcion as descCcuentadesc, c.Cformato as formatoCcuentadesc,
			a.FCestado, a.FCproceso, a.FCresponsable, a.FCtipodef, a.Ocodigo, a.ts_rversion, a.CcuentaFalt, a.CcuentaSob
		from FCajas a INNER JOIN CContables b
		ON a.Ccuenta = b.Ccuenta
		AND a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Caja#">
		LEFT JOIN CContables c ON a.Ccuentadesc = c.Ccuenta
	</cfquery>

     <cfquery name="rsCFinanciera" datasource="#session.DSN#">
        select max(CFcuenta) as CFcuenta from CFinanciera where Ccuenta = #rsCajas.Ccuenta#
        </cfquery>


    <cfquery name="rsCuenta" datasource="#session.DSN#">

                select  MntEfectivo, MntCheque
                from ERemesas
                where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.ERid#">
    </cfquery>

   <!--- <cfset monto = #form.MntEfectivo# + #rsCuenta.MntCheque#>--->
    <cfset monto = #rsCuenta.MntEfectivo# + #rsCuenta.MntCheque# >
	<cftransaction>
      <cfset Descripcion =  "Remesa Caja: " & #trim(rsCajas.FCcodigo)# & " Fecha: " & #LSDateFormat(form.Fremesa, 'dd/mm/yyyy')# >
      <!---Componentes para gener movimientos en bancos--->
                    <cfinvoke component="sif.Componentes.MB_Banco" method="SetEMovimientos" returnvariable="LvarEMid">
                        <cfinvokeargument name="BTid"               value="#rsValores.BTid#">
                        <cfinvokeargument name="CBid"               value="#form.CBid#">
                        <cfinvokeargument name="Ocodigo"            value="#rsCF.Ocodigo#">
                        <cfinvokeargument name="EMtipocambio"       value="#LvarTC#">
                        <cfinvokeargument name="EMdocumento"        value="#form.NumDeposito#">
                        <cfinvokeargument name="EMtotal"            value="#monto#">
                        <cfinvokeargument name="EMreferencia"       value="#form.NumDeposito#">
                        <cfinvokeargument name="EMdocumentoRef"      value="#form.NumDeposito#">
                        <cfinvokeargument name="EMfecha"            value="#LSParseDateTime(form.Fremesa)#">
                        <cfinvokeargument name="EMdescripcion"      value="#Descripcion#">
                        <cfinvokeargument name="TpoSocio"           value="0">


                    </cfinvoke>
                    <cfset form.EMid = "#LvarEMid#">

                    <cfinvoke component="sif.Componentes.MB_Banco" method="SetDMovimientos" returnvariable="LvarLinea">
                            <cfinvokeargument name="EMid"           value="#Form.EMid#">
                            <cfinvokeargument name="Ccuenta"        value="#rsCajas.Ccuenta#">
                            <cfinvokeargument name="ProcesoNormal"  value="false"> <!---Significa que no es de form sino que de importador  --->
                          	<cfinvokeargument name="Dcodigo"        value="#rsCF.Dcodigo#">
                            <cfinvokeargument name="CFid"           value="#rsCF.CFid#">
                            <cfinvokeargument name="DMmonto"        value="#monto#">
                            <cfinvokeargument name="DMdescripcion"  value="#Descripcion#">
                            <cfinvokeargument name="CFcuenta"       value="#rsCFinanciera.CFcuenta#">
                    </cfinvoke>

                    <cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
                        <cfinvokeargument name="Ecodigo"    value="#session.Ecodigo#"/>
                        <cfinvokeargument name="EMid"       value="#form.EMid#"/>
                        <cfinvokeargument name="usuario"    value="#session.usucodigo#"/>
                        <cfinvokeargument name="debug"      value="Y"/>
                        <cfinvokeargument name="ubicacion"  value="#0#"/>
                        <cfinvokeargument name="transaccionActiva" 	value="true"/>
                    </cfinvoke>

	</cftransaction>

     <cfset monto = #rsCuenta.MntEfectivo# + #rsCuenta.MntCheque#>

	<cfquery datasource="#session.dsn#">
		update ERemesas
        set REstado = 'A'
		where ERid =<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.ERid#">
	</cfquery>
		<cflocation url="InclusionRemesas.cfm">
</cfif>

<cffunction name="updateMonto" access="private">
<cfargument name="ERid" type="numeric" required="yes">
<cfargument name="Mcodigo" type="numeric" required="yes">
<cfargument name="LvarTabla" type="string" required="yes">
<cfquery name="rsMontoEfectivoF" datasource="#session.dsn#">
       	  select   coalesce(SUM(FPmontoori),0)  as MontoEfectivoF
            from FPagos a
            inner join ETransacciones et
                on a.ETnumero = et.ETnumero
                and a.FCid = et.FCid
           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Mcodigo#">
              and et.FACid IS NULL

              and et.FCid =  #session.Caja#
              and a.Tipo = 'E'
              <cfif isdefined ("form.NumLote")>
              and et.ETestado = 'T'
              and et.ETlote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.NumLote#">
              <cfelse>
              and et.ETestado = 'C'
              </cfif>
        </cfquery>


        <cfquery name="rsMontoEfectivoR" datasource="#session.dsn#">
         select  coalesce(SUM(FPmontoori),0)   as MontoEfectivoR
              from PFPagos a
                inner join #Arguments.LvarTabla# p
                    on a.CCTcodigo = p.CCTcodigo
                    and a.Pcodigo = p.Pcodigo
               where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Mcodigo#">
                 and p.FACid IS NULL
                 and p.FCid =  #session.Caja#
                 and a.Tipo = 'E'
                <cfif isdefined ("form.NumLote")>
                and p.Plote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.NumLote#">
                </cfif>
        </cfquery>

        <cfquery name="rsMontoVueltos" datasource="#session.dsn#">
         select
          coalesce(sum(coalesce(FPVuelto * et.ETtc,0)),0) as vuelto
        from FPagos a
        inner join ETransacciones et
          on a.ETnumero = et.ETnumero
       	 and a.FCid     = et.FCid
        where
        et.FACid IS NULL
        and et.FCid = #session.Caja#
        and ETgeneraVuelto = 1
        <cfif isdefined ("form.NumLote")>
        and et.ETestado = 'T'
        and et.ETlote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.NumLote#">
        <CFELSE>
        and et.ETestado = 'C'
       </cfif>
        </cfquery>


        <cfquery name="rsMontoChequeF" datasource="#session.dsn#">
          select
             coalesce(SUM(FPmontoori),0)   as MontoCheque
            from FPagos a
            inner join Monedas m
              on  a.Mcodigo = m.Mcodigo
            inner join ETransacciones et
                on a.ETnumero = et.ETnumero
                and a.FCid = et.FCid
           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Mcodigo#">
              and et.FACid IS NULL
              and et.FCid = #session.Caja#
              and a.Tipo = 'C'
              and a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ERid#">
              <cfif isdefined ("form.NumLote")>
              and et.ETestado = 'T'
              and et.ETlote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.NumLote#">
              <cfelse>
              and et.ETestado = 'C'
              </cfif>

        </cfquery>

		 <cfquery name="rsMontoChequeR" datasource="#session.dsn#">
		   select
              coalesce(SUM(FPmontoori),0)   as MontoCheque
          from PFPagos a
            inner join #Arguments.LvarTabla# p
                on a.CCTcodigo = p.CCTcodigo
                and a.Pcodigo = p.Pcodigo
            inner join Monedas m
                on a.Mcodigo = m.Mcodigo
           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Mcodigo#">
             and p.FACid IS NULL
             and p.FCid =  #session.Caja#
             and a.Tipo = 'C'
           	 and a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ERid#">
             <cfif isdefined ("form.NumLote")>
             and p.Plote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.NumLote#">
             </cfif>
		</cfquery>

        <cfset LvarMontoChequeU = #rsMontoChequeR.MontoCheque# + #rsMontoChequeF.MontoCheque#>


	<cfquery datasource="#session.dsn#">
		update ERemesas
        set MntCheque = #LvarMontoChequeU#
		where ERid =<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.ERid#">
	</cfquery>
</cffunction>




