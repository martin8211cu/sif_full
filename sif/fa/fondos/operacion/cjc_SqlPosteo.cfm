<!---************************ --->
<!---** AREA DE VARIABLES  ** --->
<!---************************ --->
<cfset CJX19REL = "#form.CJX19REL#">
	<!---******************************************************** --->
	<!---** Consulta de las lineas para procesar actualización ** --->
	<!---******************************************************** --->
	<cfquery name="lineas" datasource="#session.Fondos.dsn#">
		select A.CJX19REL, B.CJX20NUM, C.CJX21LIN, D.CGE1COD, D.CGE5COD, ltrim(rtrim(E.CJM07COD)) CJM07COD, D.CJX22INF, E.CJM07INT+'_M'  SP
		from CJX019 A, CJX020 B, CJX021 C, CJX022 D, CJM007 E
		where A.CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#CJX19REL#">
		and A.CJX19REL = B.CJX19REL
		and B.CJX19REL = C.CJX19REL
		and B.CJX20NUM = C.CJX20NUM
		and C.CJX19REL = D.CJX19REL
		and C.CJX20NUM = D.CJX20NUM
		and C.CJX21LIN = D.CJX21LIN
		and D.CJM07COD = E.CJM07COD
		and E.CJM07INT IS NOT NULL   
	</cfquery> 
	<!---************************************** --->
	<!---** Formatos de los campos variables ** --->
	<!---************************************** --->
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		SELECT CJM07COD,CJM08NOM, CJM08TIP FROM CJM008
	</cfquery> 
	<!---********************************************************* --->
	<!---** Armando procedimientos de actualizacion auxiliares  ** --->
	<!---********************************************************* --->
	<cfif lineas.recordcount gt 0>  <!---** inicia (si hay lineas en la CJX023 las procesa )  ** --->
		<cfset SP_Aux = "">
		<cfset Param_SP_Aux = "">
		<cfset procs = ArrayNew(1)>
		<cfset CountVar = 1>
		<cfloop query = "lineas"> 
			<cfset SP_Aux = lineas.SP> 
			<cfset SP_Aux = SP_Aux  &"   @CJX19REL="& lineas.CJX19REL>
			<cfset SP_Aux = SP_Aux  &"  ,@CJX20NUM="& lineas.CJX20NUM>
			<cfset SP_Aux = SP_Aux  &"  ,@CJX21LIN="& lineas.CJX21LIN>
			<cfset SP_Aux = SP_Aux  & " ,@CJ01ID = '" & Trim(session.Fondos.Caja) &"'" >
			<cfif len(trim(lineas.CGE1COD)) gt 0>
				<cfset SP_Aux = SP_Aux  & " ,@CGE1COD = '" & lineas.CGE1COD & "'">
			<cfelse>
				<cfset SP_Aux = SP_Aux  & " ,@CGE1COD = null">
			</cfif>
			<cfif len(trim(lineas.CGE5COD)) gt 0>
				<cfset SP_Aux = SP_Aux  &" ,@CGE5COD='" & lineas.CGE5COD &"'">
			<cfelse>
				<cfset SP_Aux = SP_Aux  &" ,@CGE5COD = null">
			</cfif>
			<cfset arreglo = listtoarray(lineas.CJX22INF,"¶")>
			<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
				<cfset arreglo2 = listtoarray(arreglo[i],"=")>
				<cfquery name="sql2" dbtype="query">
					SELECT CJM08TIP FROM rs 
					where CJM07COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lineas.CJM07COD#">
					and   CJM08NOM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arreglo2[1])#">
				</cfquery> 
				<cfswitch expression = #sql2.CJM08TIP#>
					<cfcase value="50;62;56;60" delimiters=";"> <!--- NUMERICO --->
						<cfset SP_Aux = SP_Aux  & " ,@" & Trim(arreglo2[1]) & "=" &Trim(arreglo2[2])>
					</cfcase>
					<cfcase value="47;39" delimiters=";">  <!--- ALFANUMERICO ---> 
						<cfset SP_Aux = SP_Aux  & " ,@" & Trim(arreglo2[1]) & "='" & Trim(arreglo2[2]) & "'">       
					</cfcase> 
					<cfcase value="61" delimiters=";">  <!--- Fecha ---> 
						<cfset SP_Aux = SP_Aux  & " ,@" & Trim(arreglo2[1]) & "='" & Trim(arreglo2[2]) & "'">
					</cfcase> 
				</cfswitch>
			</cfloop>
			<cfset procs[CountVar] = SP_Aux>
			<cfset CountVar = CountVar + 1>
		</cfloop>
	</cfif>  <!---** Fin (si hay lineas en la CJX023 las procesa )  ** --->
	<!---************************************** --->
	<!---** Inicia proceso de posteo         ** --->
	<!---************************************** --->
	<cfset action = "ROLLBACK">   
	<cftransaction action="begin">
		<cftry>   
			<cfquery name="rs1" datasource="#session.Fondos.dsn#">
				set nocount on 
				if object_id('##INTARP') is not null begin
					drop table ##INTARP, ##INTARP2, ##INTARP3, ##INTARP4, ##NivCon
				end				
				/******************************************/
				/*    crea temporales       			  */
				/******************************************/
				create table ##INTARP(
					INTLIN numeric(9,0) identity,
					CGE1COD char(5)  not null,
					CGE5COD varchar(5) not null,
					CGE1EAF char(5)  null,
					CGE5SAF varchar(5) null,
					PR1COD int   null,
					CP6RUB int   null,
					CP7SUB int   null,
					PRT7IDE int   null,
					PRT7CTA varchar(120) null,
					PR10COD int   null,
					PRMORI char(2)  null,
					PRMSUB char(2)  null,
					PRMTIP varchar(10) null,
					PRMDOC varchar(20) null,
					PRMLIN int   null,
					PRMREL int   null,
					PRMRF1 varchar(20) null,
					PRMRF2 varchar(15) null,
					CGM1ID int   null,
					CGM1IM char(4)  null,
					CGM1CD varchar(100) null,
					PRMOOR char(2)  null,
					PRMOSU char(2)  null,
					PRMOTI varchar(10) null,
					PRMODO varchar(20) null,
					PRMOLI int   null,
					PRMORE int   null,
					PRMOR1 varchar(20) null,
					PRMOR2 varchar(15) null,
					MONCAR money   null,
					TIPCAR float   null,
					MONCOD char(2)  null,
					FACTTIP money  null,
					INTCAN float  not null,
					INTMON money  not null,
					PRMTOP char(2)  null,
					PRMIND char(1)  null,
					PRMGAC char(1)  null,
					PRT36PR char(1)  not null,
					PRT36DC char(1)  not null,
					PRT36DE varchar(150) null,
					FECHA datetime  null,
					REF  varchar(12) null,
					CODREX int   null,
					INTIND char(1)  null
				)
				if @@error != 0 begin
					raiserror 40000 'Error creando tabla temporal (##INTARP)'
					return
				end
				create unique clustered index ##INTARP00 on ##INTARP (INTLIN)
				if @@error != 0 begin
					raiserror 40000 'Error creando indice temporal (##INTARP00)'
					return
				end
				create nonclustered index ##INTARP01 on ##INTARP (CGE1COD, CGE5COD, PR1COD, CP6RUB, CP7SUB, PRT7IDE)
				if @@error != 0 begin
					raiserror 40000 'Error creando indice temporal (##INTARP01)'
					return
				end
				create nonclustered index ##INTARP02 on ##INTARP (PRMORI, PRMSUB, PRMTIP, PRMDOC, PRMLIN, PRMREL, PRMRF1, PRMRF2, MONCOD, PRMTOP)
				if @@error != 0 begin
					raiserror 40000 'Error creando indice temporal (##INTARP02)'
					return
				end
				create nonclustered index ##INTARP03 on ##INTARP (PRMOOR, PRMOSU, PRMOTI, PRMODO, PRMOLI, PRMORE, PRMOR1, PRMOR2)
				if @@error != 0 begin
					raiserror 40000 'Error creando indice temporal (##INTARP03)'
					return
				end
				create table ##INTARP2(
					INTLIN numeric(9,0) identity,
					CGE1COD char(5)  not null,
					CGE5COD varchar(5) not null,
					PR1COD int   not null,
					CP6RUB int   not null,
					CP7SUB int   not null,
					PRT7IDE int   not null,
					PRMORI char(2)  null,
					PRMSUB char(2)  null,
					PRMTIP varchar(10) null,
					PRMDOC varchar(20) null,
					PRMREL int   null,
					PRMRF1 varchar(20) null,
					PRMRF2 varchar(15) null,
					MONCOD char(2)  not null,
					PRMTOP char(2)  not null,
					PRMIND char(1)  null,
					FACTTIP money  not null,
					MONCAR money  null,
					TIPCAR float  null,
					INTCAN int   not null,
					INTMON money  not null,
					ESTREC smallint  null,
					MONREC money  null,
					CANREC int   null,
					MONDIS money  null,
					MONPRE money  null,
					MONEXC money  null,
					MONRES money  null,
					MONCOM money  null,
					MONGAS money  null,
					CANDIS int   null,
					ESTSOB smallint  null,
					MONSOB money  null,
					CANSOB int   null,
					INTCAE int   null,
					MESINI int   null,
					MESFIN int   null,
					INTCMT money  null,
					INTNRZ int   null,
					INTLRZ int   null,
					CODREX int   null,
					INTIND char(1)  null
				)
				if @@error != 0 begin
					raiserror 40000 'Error creando tabla temporal (##INTARP2)'
					return
				end
				create unique clustered index ##INTARP200 on ##INTARP2 (INTLIN)
				if @@error != 0 begin
					raiserror 40000 'Error creando indice temporal (##INTARP200)'
					return
				end
				create nonclustered index ##INTARP201 on ##INTARP2 (CGE1COD, CGE5COD, PR1COD, CP6RUB, CP7SUB, PRT7IDE)
				if @@error != 0 begin
					raiserror 40000 'Error creando indice temporal (##INTARP201)'
					return
				end
				create nonclustered index ##INTARP202 on ##INTARP2 (PRMORI, PRMSUB, PRMTIP, PRMDOC, PRMREL, PRMRF1, PRMRF2, MONCOD, PRMTOP)
				if @@error != 0 begin
					raiserror 40000 'Error creando indice temporal (##INTARP202)'
					return
				end
				create table ##INTARP3(
					PERCOD int   not null,
					PRT22SUB int   not null,
					CGE1COD char(5)  not null,
					CGE5COD varchar(5) not null,
					PR1COD int   not null,
					CP6RUB int   not null,
					CP7SUB int   not null,
					PRT7IDE int   null,
					PRMORI char(2)  not null,
					PRMSUB char(2)  not null,
					PRMTIP varchar(10) not null,
					PRMDOC varchar(20) not null,
					PRMLIN int   not null,
					PRMREL int   null,
					PRMRF1 varchar(20) null,
					PRMRF2 varchar(15) null,
					PRT39ID int   null,
					PRT40ID int   null,
					PRMTOP char(2)  not null,
					MONCOD char(2)  not null,
					FACTTIP money  not null,
					INTCAN float  not null,
					INTMON money  not null,
					EXCCAN float  null,
					EXCMON money  null,
					DIFCAN float  null,
					DIFMON money  null,
					CODREX int   null 
				)
				if @@error != 0 begin
					raiserror 40000 'Error creando tabla temporal (##INTARP3)'
					return
				end
				create nonclustered index ##INTARP301 on ##INTARP3 (PERCOD, PRT22SUB, CGE1COD, CGE5COD, PR1COD, CP6RUB, CP7SUB, PRT7IDE)
				if @@error != 0 begin
					raiserror 40000 'Error creando indice temporal (##INTARP301)'
					return
				end
				create nonclustered index ##INTARP302 on ##INTARP3 (PRMORI, PRMSUB, PRMTIP, PRMDOC, PRMLIN, PRMREL, PRMRF1, PRMRF2, MONCOD)
				if @@error != 0 begin
					raiserror 40000 'Error creando indice temporal (##INTARP302)'
					return
				end
				create table ##INTARP4(
					CGE1COD char(5)  not null,
					CGE5COD varchar(5) not null,
					PR1COD int   not null,
					CP6RUB int   not null,
					CP7SUB int   not null,
					PRT7IDE int   null,
					INTCAN float  not null,
					INTPRE money  null,
					INTRES money  null,
					INTCOM money  null,
					INTGAS money  null,
					INTAJU money  null,
					INTEXC money  null,
					CODREX int   null
				)
				if @@error != 0 begin
					raiserror 40000 'Error creando tabla temporal (##INTARP4)'
					return
				end
				create table ##NivCon(
					nivel smallint  not null,
					tipo  int   not null,
					valor char(100)  not null,
					CG  bit 
				)
				if @@error != 0 begin
					raiserror 40000 'Error creando tabla temporal (##NivCon)'
					return
				end    

				/******************************************/
				/*    ejecuta posteo masivo				  */
				/******************************************/
				declare @error int
				exec @error = cj_PosteoGastos_Masiva_II
				@CJX19REL =  <cfqueryparam cfsqltype="cf_sql_integer" value="#CJX19REL#">
				, @usr      =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">    
	
				if @@error != 0 or @error != 0 begin
					drop table ##INTARP, ##INTARP2, ##INTARP3, ##INTARP4, ##NivCon
					raiserror 40000 'Error al aplicar la transaccion. '
					return
				end
				
				drop table ##INTARP, ##INTARP2, ##INTARP3, ##INTARP4, ##NivCon
				/*select  'Aplicacion de documentos realizada con exito.' as Resultado*/
				set nocount off 	
			</cfquery>
			<cfif lineas.recordcount gt 0  and rs1.Resultado neq 'N'>
				<cfloop from="1" to="#arraylen(procs)#" index="valor">
					<cfset sp = "#procs[valor]#">
					<cfquery name="rs2" datasource="#session.Fondos.dsn#">	
						declare @error int
						/******************************************/
						/*    Actualiza los auxiliares 			  */
						/*	  linea  por linea 				      */
						/******************************************/
						
						exec @error = #PreserveSingleQuotes(sp)#
						if @error != 0 begin
						raiserror 40000 'Error en actualización de auxiliares'	
						return
						end
					</cfquery>
				</cfloop>  
			</cfif> 
			<cfcatch type="any">	
				<cfset action = "ROLLBACK">
				<cftransaction action = "#action#"/>   
				<script language="JavaScript">
					var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
					mensaje = mensaje.substring(40,300)
					alert(mensaje)
					history.back()
				</script>
				<cfabort>
			</cfcatch> 
   	    </cftry>  
		<cfset action = "COMMIT">
		<cftransaction action = "#action#"/>   
	</cftransaction>
	<cfif rs1.Resultado neq 'N'>
		<cfset CJX19REL = 0 >
		<cfset RESPOSTEO = rs1.Resultado> 
	<cfelse>
 		<cfset RESPOSTEO = rs1.NUMERO> 
	</cfif>
	<cfset modo = "ALTA">
	<cflocation url="../operacion/cjc_PrincipalGasto.cfm?mododet=ALTA&modo=ALTA&CJX19REL=#CJX19REL#&RESPOSTEO=#RESPOSTEO#">

 <script language="JavaScript">
/*
        Resultado = "<cfoutput>#rs1.Resultado#</cfoutput>"
	if (Resultado == 'N'){
            Resultado = "Algunos de los gastos de la relación no cuentan con presupuesto, proceso cancelado"  
        }
	alert(Resultado)
   top.frames['workspace'].location.href = "../operacion/cjc_PrincipalPosteo.cfm?CJX19REL=0"	
*/
</script>

