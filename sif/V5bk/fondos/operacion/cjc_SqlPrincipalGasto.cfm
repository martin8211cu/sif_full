<!---************************ --->
<!---** AREA DE VARIABLES  ** --->
<!---************************ --->
<cfset modo = "ALTA">
<cfset mododet = "ALTA">
<cfset RESPOSTEO = "">
<cfset CJX19REL = form.CJX19REL>
 
<!---*********************************** --->
<!---** VARIFICACION DE CAMPOS Y ABC  ** --->
<!---*********************************** --->
<!---La validacion de cuenta hace un form.submit() automatico y por tanto no se presiona el boton
pero en botonsel viene el ultimo boton presionado--->
<cfparam name="form.#form.botonSel#" default="1">
 
<cfif isdefined("form.Nuevodet")>
	<cfset modo = 'CAMBIO'>
</cfif>
 
<cfif isdefined("form.AltaNueva")>
	<cfset form.Alta = '1'>
</cfif>

<cfif isdefined("form.Alta")>
	<cfset form.Altadet = '1'>
</cfif>
 
<cfif isdefined("form.Altadet") or isdefined("form.Cambiodet")>
	<cfset modo = 'CAMBIO'>
	<cfset form.Cambio = '1'>
</cfif>
<!---************************************************************* --->
<!---**  AQUI SE LE DA MANTIENIMIENTO A LAS SIGUIENTES TABLAS   ** --->
<!---**  CJX019,CJX020,CJX021,CJX022,CJX023                     ** --->
<!---**  Y ADEMAS SE EJECUTAN LOS PROCEDIMENTOS DE POSTEO       ** --->
<!---**  Y  VALIDACION Y ACTUALIZACION DE AUXILIARES            ** --->
<!---************************************************************* --->
<cfif not isdefined("form.Nuevo")>
	<cftransaction> 
	<cftry>
		<cfquery datasource="#session.Fondos.dsn#"  name="sql" > 
			set nocount on 
			<!---*************************************** --->
			<!---**            ALTA         		  ** --->
			<!---*************************************** --->
			<cfif isdefined("form.Alta")>
				declare @CJX19REL int ,@CJX20NUM  int
				<cfif CJX19REL EQ 0 >
					select @CJX19REL = isnull(max(CJX19REL), 0) + 1  from CJX019
					insert  CJX019 (CJX19REL,CJ1PER,CJ1MES,CJ01ID,CJX19USR,CJX19FED, CJX19EST)
					values (
					@CJX19REL,
					<cfqueryparam  cfsqltype="cf_sql_integer" value="#trim(session.Fondos.Anno)#" >,
					<cfqueryparam  cfsqltype="cf_sql_integer" value="#trim(session.Fondos.Mes)#" >,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(session.Fondos.Caja)#" >,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(session.usuario)#" >,
					getdate(),
					'D'
					)
				<cfelse>
					select @CJX19REL = <cfqueryparam  cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" >
				</cfif>
				select @CJX20NUM = isnull(max(CJX20NUM), 0) + 1  from CJX020 WHERE CJX19REL =@CJX19REL
				
				insert CJX020 (    CJX19REL, CJX20NUM, CJX20TIP,
				PROCOD,  CJX20NUF,   CJX20FEF,
				EMPCOD,  CJX20TOT,   CJX20DES,
				CJX20MUL, CJX20RET,   CJX20IMP,
				CJX20MNT, CP9COD,     I04COD)
				VALUES (
				@CJX19REL,
				@CJX20NUM,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CJX20TIP)#" >,
				<cfif len(trim(form.PROCOD)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.PROCOD)#" ><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CJX20NUF)#" >,
				convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CJX20FEF)#" >, 103), 
				<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.EMPCOD)#" >,
				<cfqueryparam cfsqltype="cf_sql_float"  value="#trim(form.CJX20TOT)#" >,
				<cfqueryparam cfsqltype="cf_sql_float"  value="#trim(form.CJX20DES)#" >,
				<cfqueryparam cfsqltype="cf_sql_float"  value="#trim(form.CJX20MUL)#" >,
				<cfqueryparam cfsqltype="cf_sql_float"  value="#trim(form.CJX20RET)#" >,
				<cfqueryparam cfsqltype="cf_sql_float"  value="#trim(form.CJX20IMP)#" >,
				<cfqueryparam cfsqltype="cf_sql_float"  value="#trim(form.CJX20MNT)#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CP9COD)#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.DEPCOD)#" >
				)
				<cfset modo = "CAMBIO">
				select @CJX19REL as CJX19REL,@CJX20NUM as CJX20NUM	
			<!---*************************************** --->
			<!---**            CAMBIO                 ** --->
			<!---*************************************** --->
			<cfelseif isdefined("form.Cambio")>
				UPDATE CJX020 SET 
				CJX20TIP  = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJX20TIP)#" >,
				PROCOD   = <cfif len(trim(form.PROCOD)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.PROCOD)#" ><cfelse>null</cfif>,
				CJX20NUF  = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJX20NUF)#" >,
				CJX20FEF  = convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CJX20FEF)#" >, 103),
				EMPCOD   = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#trim(form.EMPCOD)#" >,
				CJX20TOT  = <cfqueryparam cfsqltype="cf_sql_float"    value="#trim(form.CJX20TOT)#" >,
				CJX20DES  = <cfqueryparam cfsqltype="cf_sql_float"    value="#trim(form.CJX20DES)#" >,
				CJX20MUL  = <cfqueryparam cfsqltype="cf_sql_float"    value="#trim(form.CJX20MUL)#" >,
				CJX20RET  = <cfqueryparam cfsqltype="cf_sql_float"    value="#trim(form.CJX20RET)#" >,
				CJX20IMP  = <cfqueryparam cfsqltype="cf_sql_float"    value="#trim(form.CJX20IMP)#" >,
				CJX20MNT  = <cfqueryparam cfsqltype="cf_sql_float"    value="#trim(form.CJX20MNT)#" >,
				CP9COD   = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#trim(form.CP9COD)#" >,
				I04COD   = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#trim(form.DEPCOD)#" >
				WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#trim(form.CJX19REL)#" > 
				AND   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer"  value="#trim(form.CJX20NUM)#" > 
				AND   timestamp = convert(varbinary,#lcase(Form.timestamp)#)
				<cfset modo = "CAMBIO">
			<!---*************************************** --->
			<!---**            BAJA 				  ** --->
			<!---*************************************** --->
			<cfelseif isdefined("form.Baja")>
				DELETE CJX020 
				WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX19REL)#" > 
				AND   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX20NUM)#" >
				AND   timestamp = convert(varbinary,#lcase(Form.timestamp)#)
			<!---*************************************** --->
			<!---**            BAJA RELACION     	  ** --->
			<!---*************************************** --->
			<cfelseif isdefined("form.BajaR")>
				update CJX019  set CJX19EST = 'B'
				WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX19REL)#" > 
				
				DELETE CJX023
				WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX19REL)#" > 
				
				DELETE CJX022
				WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX19REL)#" > 
				
				DELETE CJX021
				WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX19REL)#" >
				
				DELETE CJX020
				WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX19REL)#" >
				<cfset CJX19REL = 0 >
				<cfset modo = "ALTA">
			</cfif> 
			set nocount off
		</cfquery>

		<!---************************************* --->
		<!---**   INICIANDO VARIABLES SEGUN MODO ** --->
		<!---************************************* --->
		<cfif isdefined("form.Alta")>
			<cfset CJX19REL = sql.CJX19REL >
			<cfset CJX20NUM = sql.CJX20NUM >
		<cfelse>
			<cfset CJX19REL = form.CJX19REL >
			<cfset CJX20NUM = form.CJX20NUM >
		</cfif>
		<!---************************************* --->
		<!---**   VERIFICACIONES DEL DETALLE    ** --->
		<!---************************************* --->
		<cfset CJX22INF = "">
		<cfset PROCEDIMIENTO = "">		
		<cfif NOT isdefined("form.Nuevodet")>
			<cfif isdefined("form.Altadet") OR isdefined("form.Cambiodet")>
			   <!---************************************************ --->
			   <!---** SQL QUE TRAE PROCEDIMIENTO  DE VALIDACION  ** --->
			   <!---************************************************ --->
				<cfquery datasource="#session.Fondos.dsn#"  name="sql3" > 
					SELECT  ltrim(rtrim(CJM07VAL))+'_M' CJM07VAL FROM  CJM007
					WHERE  CJM07COD =<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJM07COD)#" >
				</cfquery>
				<!---************************************************ --->
				<!---** SQL QUE TRAE FECHA PARA VALIDACION         ** --->
				<!---************************************************ --->
				<cfquery datasource="#session.Fondos.dsn#"  name="sql4" > 
					SELECT  CJX20FEF
					FROM  CJX020
					WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" > 
					AND   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX20NUM)#" >
				</cfquery> 
				<!---************************************************ --->
				<!---** SQL QUE ARMA PARAMENTROS DEL  DET.         ** --->
				<!---************************************************ --->
				<cfquery datasource="#session.Fondos.dsn#"  name="sql2" > 
					SELECT  CJM08NOM,CJM08TIP  
					FROM CJM008  
					WHERE  CJM07COD =<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJM07COD)#" >
				</cfquery> 
				<!---************************************************** --->
				<!---**   ARMA EL PROCEDIMIENTO DE VALIDACION        ** --->
				<!---**   Y ADEMAS  LA HILERA  CJX22INF              ** --->
				<!---**   CUANDO NO HAY VALIDACION                   ** --->
				<!---************************************************** --->
				<cfloop query="sql2"> 
					<cfswitch expression = #sql2.CJM08TIP#>
						<cfcase value="50;62;56;60" delimiters=";"> <!--- NUMERICO --->
							<cfset PROCEDIMIENTO = PROCEDIMIENTO &",@"& sql2.CJM08NOM &"="& Trim('#Evaluate('form.#Evaluate('sql2.CJM08NOM')#')#')>
							<cfset CJX22INF = CJX22INF & sql2.CJM08NOM &"="& Trim('#Evaluate('form.#Evaluate('sql2.CJM08NOM')#')#') & "¶">
						</cfcase>
						<cfcase value="47;39" delimiters=";">  <!--- ALFANUMERICO --->
							<cfset PROCEDIMIENTO = PROCEDIMIENTO  &",@"& sql2.CJM08NOM &"='"& Trim('#(Evaluate('form.#Evaluate('sql2.CJM08NOM')#'))#')&"'">
							<cfset CJX22INF = CJX22INF & sql2.CJM08NOM &"="& Trim('#Evaluate('form.#Evaluate('sql2.CJM08NOM')#')#') & "¶">
						</cfcase>
						<cfcase value="61" delimiters=";">  <!--- Fecha --->
							<cfset PROCEDIMIENTO = PROCEDIMIENTO  &",@"& sql2.CJM08NOM &"='"& #Trim((dateformat(Evaluate(Evaluate('sql2.CJM08NOM')),"yyyymmdd")))#&"'">
							<cfset CJX22INF = CJX22INF & sql2.CJM08NOM &"="& #Trim((dateformat(Evaluate(Evaluate('sql2.CJM08NOM')),"yyyymmdd")))#&"¶">
						</cfcase>     
					</cfswitch>
				</cfloop>
				<!---************************************************** --->
				<!---**   SI LA HILERA CJX22INF TIENE VALOR  ELIMINA  ** --->
				<!---**   ESTE CARACTER '¶' AL FINAL DE LA HILERA     ** --->
				<!---************************************************** --->
				<cfif len(trim(CJX22INF)) gt 0> 
					<cfset CJX22INF = mid(CJX22INF, 1, len(trim(CJX22INF)) -1)>
				</cfif>
				<!---************************************************** --->
				<!---**   SI HAY PROCEDIMIENTO DE VALIDACION         ** --->
				<!---**   SE EJECUTA EL PROC  O LOS PROCS            ** --->
				<!---************************************************** --->
				<cfif len(trim(sql3.CJM07VAL)) gt 2> 
						<cfquery datasource="#session.Fondos.dsn#"  name="proc" >
							set nocount on
							exec  #sql3.CJM07VAL#
							@CJ01ID = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#trim(session.Fondos.Caja)#" >
							,@CJX19REL = <cfqueryparam  cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" >
							,@CJX20NUM = <cfqueryparam  cfsqltype="cf_sql_integer" value="#trim(CJX20NUM)#" >
							,@CJX21MNT = <cfqueryparam  cfsqltype="cf_sql_integer" value="#trim(CJX21MNT)#" >
							,@CJX20FEC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(sql4.CJX20FEF)#" >
							,@CGM1ID = <cfqueryparam  cfsqltype="cf_sql_integer" value="#trim(form.CGM1ID)#" >
							,@CGM1IM = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#trim(form.CGM1IM)#" >
							,@CGM1CD = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#trim(form.CGM1CD)#" >
							#PreserveSingleQuotes(PROCEDIMIENTO)#
							set nocount off
						</cfquery> 
					<cfset CJX22INF = proc.cadena>
				</cfif>
			</cfif>
		</cfif>	
		<cfquery datasource="#session.Fondos.dsn#"  name="sql" > 
			set nocount on 
			<!---*************************************** --->
			<!---**            ALTA DETALLE           ** --->
			<!---*************************************** --->
			<cfif isdefined("form.Altadet")>
				declare @CJX19REL int ,@CJX20NUM  int ,@CJX21LIN int
				select @CJX19REL = <cfqueryparam  cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" >
				select @CJX20NUM = <cfqueryparam  cfsqltype="cf_sql_integer" value="#trim(CJX20NUM)#" >

				select @CJX21LIN = isnull(max(CJX21LIN), 0) + 1  from CJX021 
				WHERE CJX19REL =@CJX19REL and  CJX20NUM = @CJX20NUM
				INSERT CJX021(
					 CJX19REL, CJX20NUM, CJX21LIN, CJX21TIP, CJX21MDU
					 ,CJX21IIN, CJX21DSC, CJX21CAN, CJX21PRE, CJX21PDS
					 ,CJX21MDS, CJX21MNT, CJX21IGA, CJX21ICF, CJM16COD
					 ,CGE1COD, CGE5COD, PR1COD,  PRT7IDE, CP6RUB
					 ,CP7SUB, CJM12ID, CJM13ID, CJM07COD, I92COD
					 ,I06COD, CGM1ID,  CGM1IM,  CGM1CD
				)
				VALUES (
					 @CJX19REL,
					 @CJX20NUM,
					 @CJX21LIN,
					 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJX21TIP)#" >,
					 <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21MDU)#" >,
					 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJX21IIN)#" >,
					 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJX21DSC)#" >,
					 <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21CAN)#" >,
					 <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21PRE)#" >,
					 <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21PDS)#" >,
					 <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21MDS)#" >,
					 <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21MNT)#" >,
					 <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21IGA)#" >,
					 <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21ICF)#" >,
					 <cfif len(trim(form.CJM16COD)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJM16COD)#" ><cfelse>null</cfif>,    
					 ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CGE1COD)#" >)),
					 ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CGE5COD)#" >)),
					 <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.PR1COD)#" >,
					 <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.PRT7IDE)#" >,
					 <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.CP6RUB)#" >,
					 <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.CP7SUB)#" >,
					 <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.CJM12ID)#" >,
					 <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.CJM13ID)#" >,
					 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJM07COD)#" >,
					 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.I92COD)#" >,
					 <cfif len(trim(form.I06COD)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.I06COD)#" ><cfelse>null</cfif>,    
					 <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.CGM1ID)#" >,
					 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CGM1IM)#" >,
					 <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CGM1CD)#" >
				)
				<cfif len(trim(CJX22INF)) NEQ 0>
					 INSERT CJX022 (CJX19REL ,CJX20NUM, CJX21LIN,CJM07COD,CJX22INF,CGE1COD ,CGE5COD) 
					 VALUES (
						 @CJX19REL,
						 @CJX20NUM,
						 @CJX21LIN, 
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJM07COD)#" >,
						ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(CJX22INF)#" >)),
						<cfif isdefined ("proc.empresa") and  proc.empresa neq "">
							<cfif len(trim(proc.empresa)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(proc.empresa)#" ><cfelse>null</cfif>,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined ("proc.sucursal") and  proc.sucursal neq "">
							<cfif len(trim(proc.sucursal)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(proc.sucursal)#" ><cfelse>null</cfif>
						<cfelse>
							null
						</cfif>
					)
				</cfif>
				exec  cj_CalculaImpuestos_masivo
				@CJX19REL = @CJX19REL,
				@CJX20NUM =@CJX20NUM
				<cfset modo = "CAMBIO">
				<cfset mododet = "ALTA">
			 <!---*************************************** --->
			 <!---**            CAMBIO  DETALLE        ** --->
			 <!---*************************************** --->
			<cfelseif isdefined("form.Cambiodet")>
				UPDATE CJX021 SET
				CJX21TIP =    <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJX21TIP)#" >,
				CJX21MDU =   <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21MDU)#" >,
				CJX21IIN =      <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJX21IIN)#" >,
				CJX21DSC =   <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJX21DSC)#" >,
				CJX21CAN =   <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21CAN)#" >,
				CJX21PRE =   <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21PRE)#" >,
				CJX21PDS =   <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21PDS)#" >,
				CJX21MDS =   <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21MDS)#" >,
				CJX21MNT =   <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21MNT)#" >,
				CJX21IGA =   <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21IGA)#" >,  
				CJX21ICF =   <cfqueryparam cfsqltype="cf_sql_money"   value="#trim(form.CJX21ICF)#" >, 
				CJM16COD =   <cfif len(trim(form.CJM16COD)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJM16COD)#" ><cfelse>null</cfif>,
				CGE1COD =    ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CGE1COD)#" >)),
				CGE5COD =    ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CGE5COD)#" >)),
				PR1COD =     <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.PR1COD)#" >, 
				PRT7IDE =     <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.PRT7IDE)#" >,
				CP6RUB =     <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.CP6RUB)#" >, 
				CP7SUB =      <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.CP7SUB)#" >,
				CJM12ID =    <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.CJM12ID)#" >,  
				CJM13ID =      <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.CJM13ID)#" >,
				CJM07COD =   <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJM07COD)#" >,
				I92COD =    <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.I92COD)#" >,
				I06COD =    <cfif len(trim(form.I06COD)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.I06COD)#" ><cfelse>null</cfif>, 
				CGM1ID =    <cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.CGM1ID)#" >,
				CGM1IM =    <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CGM1IM)#" >,
				CGM1CD =  <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CGM1CD)#" >
				WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" > 
				AND   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX20NUM)#" >
				AND   CJX21LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX21LIN)#" > 
				AND   timestamp = convert(varbinary,#lcase(Form.timestampdet)#)
	
				exec  cj_CalculaImpuestos_masivo
				@CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" >,
				@CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX20NUM)#" >  
	
				if (SELECT isnull(count(*),0)
					FROM CJX022  
					WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" > 
					AND   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX20NUM)#" >
					AND   CJX21LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX21LIN)#" > 
				) <> 0
				BEGIN
				<cfif len(trim(CJX22INF)) NEQ 0>
					UPDATE CJX022 SET
					CJM07COD =  <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJM07COD)#" >,
					CJX22INF = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(CJX22INF)#" >)),
					<cfif isdefined ("proc.empresa") and  proc.empresa neq "">
						CGE1COD  =  <cfif len(trim(proc.empresa)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(proc.empresa)#" ><cfelse>null</cfif>,
					<cfelse>
						CGE1COD  =  null,
					</cfif>
					<cfif isdefined ("proc.sucursal") and  proc.sucursal neq "">
						CGE5COD  =  <cfif len(trim(proc.sucursal)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(proc.sucursal)#" ><cfelse>null</cfif>
					<cfelse>
						CGE5COD  =  null
					</cfif>     
					 WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" > 
					 AND   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX20NUM)#" >
					 AND   CJX21LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX21LIN)#" > 
					<cfif isdefined ("Form.timestampdet2") and  Form.timestampdet2 neq "">
						AND   timestamp = convert(varbinary,#lcase(Form.timestampdet2)#)
					</cfif>
				<cfelse>
					DELETE CJX022 
					WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" > 
					AND   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX20NUM)#" >
					AND   CJX21LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX21LIN)#" > 
				</cfif>
				END
				<cfif len(trim(CJX22INF)) NEQ 0>
					ELSE
					BEGIN
					INSERT CJX022 (CJX19REL ,CJX20NUM, CJX21LIN,CJM07COD,CJX22INF,CGE1COD ,CGE5COD) 
					VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" >,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX20NUM)#" >,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX21LIN)#" >, 
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(form.CJM07COD)#" >,
						ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(CJX22INF)#" >)),
						<cfif isdefined ("proc.empresa") and  proc.empresa neq "">
							<cfif len(trim(proc.empresa)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(proc.empresa)#" ><cfelse>null</cfif>,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined ("proc.sucursal") and  proc.sucursal neq "">
							<cfif len(trim(proc.sucursal)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(proc.sucursal)#" ><cfelse>null</cfif>
						<cfelse>
							null
						</cfif>     
					)
					END 
				</cfif>  
				<cfset modo = "CAMBIO">
				<cfset mododet = "CAMBIO">
			<!---*************************************** --->
			<!---**            BAJA  DETALLE          ** --->
			<!---*************************************** --->
			<cfelseif isdefined("form.Bajadet")>
				DELETE CJX021 
				WHERE CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" > 
				AND   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX20NUM)#" >
				AND   CJX21LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.CJX21LIN)#" > 
				AND   timestamp = convert(varbinary,#lcase(Form.timestampdet)#)

				exec  cj_CalculaImpuestos_masivo
				@CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" >,
				@CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX20NUM)#" >  
				<cfset mododet = "ALTA">
				<cfset modo = "CAMBIO">
			</cfif>
			set nocount off
		</cfquery>
		<cfcatch type="any">
			<script language="JavaScript">
			   var  mensaje = "<cfoutput>#trim(cfcatch.Detail)#</cfoutput>"
			   mensaje = mensaje.substring(40,300)
			   alert(mensaje)
			   history.back()
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
	</cftransaction>
</cfif>
<!---******************************************* --->
<!---**  MODO EN QUE SE DEVUELVE LA PANTALLA  ** --->
<!---******************************************* --->
<!---******************************************************************************************* --->
<!---**      POSTEO                                 ** --->
<!---******************************************************************************************* ---> 
<cfif isdefined("form.Posteo")>
	<!---******************************************************** --->
	<!---** Consulta de las lineas para procesar actualización ** --->
	<!---******************************************************** --->
	<cfquery name="lineas" datasource="#session.Fondos.dsn#">
		select A.CJX19REL, B.CJX20NUM, C.CJX21LIN, D.CGE1COD, D.CGE5COD, ltrim(rtrim(E.CJM07COD)) CJM07COD, D.CJX22INF, E.CJM07INT+'_M'  SP
		from CJX019 A, CJX020 B, CJX021 C, CJX022 D, CJM007 E
		where A.CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(CJX19REL)#" >
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
					where CJM07COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(lineas.CJM07COD)#" >
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
				@CJX19REL =  #CJX19REL#
				, @usr      =  '#session.usuario#'    

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
	<cflocation url="../../operacion/cjc_PrincipalGasto.cfm?mododet=ALTA&modo=ALTA&CJX19REL=#CJX19REL#&RESPOSTEO=#RESPOSTEO#">
</cfif>



<cfif modo eq "ALTA" OR isdefined("form.AltaNueva")>
	<cflocation url="../../operacion/cjc_PrincipalGasto.cfm?mododet=ALTA&modo=ALTA&CJX19REL=#CJX19REL#">
<cfelseif mododet eq "ALTA">
	<cflocation url="../../operacion/cjc_PrincipalGasto.cfm?mododet=ALTA&modo=CAMBIO&CJX19REL=#CJX19REL#&CJX20NUM=#CJX20NUM#">
<cfelse>
	<cflocation url="../../operacion/cjc_PrincipalGasto.cfm?mododet=CAMBIO&modo=CAMBIO&CJX19REL=#CJX19REL#&CJX20NUM=#CJX20NUM#&CJX21LIN=#form.CJX21LIN#">
</cfif>