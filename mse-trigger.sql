DROP TABLE IF EXISTS verify_mse;
DROP TRIGGER IF EXISTS INFOMSEXP_INSERT;
CREATE TRIGGER INFOMSEXP_INSERT BEFORE INSERT ON INFOMSEXP BEGIN SELECT CASE
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '01.01')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;' OR 
            NEW.ELEMENT_VALUE <> CAST(NEW.ELEMENT_VALUE AS INT))
        ) THEN RAISE(ABORT, '[sql-debug] Нет номера протокола (п. 01.01)')

        WHEN --ТУТ дата протокола - '01.02'
        (
            NEW.MSE_END = 'Y' AND
            NEW.ELEMENT_NAME = '01.02' AND
            (julianday(DATE('now', 'localtime')) - julianday(DATE(SUBSTR(NEW.ELEMENT_VALUE, 7, 4) || '-' || SUBSTR(NEW.ELEMENT_VALUE, 4, 2) || '-' || SUBSTR(NEW.ELEMENT_VALUE, 1, 2))) < 0 OR
            (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;'))
        ) THEN RAISE(ABORT, '[sql-debug] Дата протокола (п. 01.02) не может пустой или будущей!') 
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '04.0')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет даты выдачи направления')
        
        WHEN (
            (NEW.MSE_END = 'Y')       
            AND (
                SELECT COUNT(*)
                FROM INFOMSEXP
                WHERE IDMSEXP = NEW.IDMSEXP
                    AND (ELEMENT_VALUE = '' OR ELEMENT_VALUE = ' ' OR ELEMENT_VALUE IS NULL)  
                    AND (ELEMENT_NAME = '05.01'
                    OR ELEMENT_NAME = '05.02'
                    OR ELEMENT_NAME = '05.03'
                    OR ELEMENT_NAME = '05.04'
                    OR ELEMENT_NAME = '05.05'
                    OR ELEMENT_NAME = '05.06'
                    OR ELEMENT_NAME = '05.07'
                    OR ELEMENT_NAME = '05.08'
                    OR ELEMENT_NAME = '05.09'
                    OR ELEMENT_NAME = '05.10'
                    OR ELEMENT_NAME = '05.11')
            ) = 11
        ) THEN RAISE(ABORT, '[sql-debug] В пункте 5 должен быть выбран один вариант!')
	
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '06.1')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет фамилии (п. 06.1)')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '06.2')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] [sql-debug] Нет имени (п. 06.2)')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '06.3')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] [sql-debug] Нет отчества (п. 06.3)')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '07.1')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет даты рождения (п. 07.1)')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '07.2')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;' OR
            NEW.ELEMENT_VALUE <> CAST(NEW.ELEMENT_VALUE AS INT))
        ) THEN RAISE(ABORT, '[sql-debug] Возраст должен быть целым числом (п. 07.2)!')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '08')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет поля пол (п. 08)')
        
		
		WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '11.2')
            AND ((new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;') OR 
			NEW.ELEMENT_VALUE <> CAST(NEW.ELEMENT_VALUE AS INT) OR 
			CAST(NEW.ELEMENT_VALUE AS INT) > 999999 OR 
			CAST(NEW.ELEMENT_VALUE AS INT) < 100000)
        ) THEN RAISE(ABORT, '[sql-debug] Почтовый индекс должен состоять из 6 цифр!')
        
		
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '15')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет СНИЛС (п. 15)')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '16.1')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет наименования документа')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '16.2.1')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет серии документа')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '16.2.2')
            AND (new.ELEMENT_VALUE = ''OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет номера документа')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '16.3')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет кем выдан документ')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '16.4')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет даты выдачи документа')
        
        WHEN (
            NEW.MSE_END = 'Y'
            AND NEW.ELEMENT_NAME = '16.5'
            AND (
                NEW.ELEMENT_VALUE = ''
                OR NEW.ELEMENT_VALUE IS NULL
                OR NEW.ELEMENT_VALUE = ' '
            )
            AND (
                SELECT ELEMENT_VALUE
                FROM INFOMSEXP
                WHERE ELEMENT_NAME = '16.1'
                    AND IDMSEXP = NEW.IDMSEXP
            ) = '1'
        ) THEN RAISE(
            ABORT, '[sql-debug] В пункте 16.5 введите код подразделения, выдавшего паспорт!')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '16.6.3')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет номера полиса')
        

        --Тип полиса ВРЕМЕННОЕ СВИДЕТЕЛЬСТВО
        --(@F16.6.2=ВС)and(@F16.7.1#2)
        WHEN NEW.MSE_END = 'Y'
        AND NEW.ELEMENT_NAME = '16.7.1'
        AND (NEW.ELEMENT_VALUE <> '2')
        AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '16.6.2'
                AND IDMSEXP = NEW.IDMSEXP
        ) = 'ВС' THEN RAISE(
            ABORT, '[sql-debug] Тип полиса ВРЕМЕННОЕ СВИДЕТЕЛЬСТВО!') 
            

        --Тип полиса ПОЛИС ЕДИНОГО ОБРАЗЦА
        --(@F16.6.2=ЕП)and(@F16.7.1#3)
        WHEN NEW.MSE_END = 'Y'
        AND NEW.ELEMENT_NAME = '16.7.1'
        AND (NEW.ELEMENT_VALUE <> '3')
        AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '16.6.2'
                AND IDMSEXP = NEW.IDMSEXP
        ) = 'ЕП' THEN RAISE(
            ABORT,
            '[sql-debug] Тип полиса ПОЛИС ЕДИНОГО ОБРАЗЦА!'
        ) --Серия полиса ВС
        --(@F16.6.2#ВС)and(@F16.7.1=2)
        WHEN NEW.MSE_END = 'Y'
        AND NEW.ELEMENT_NAME = '16.7.1'
        AND (NEW.ELEMENT_VALUE = '2')
        AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '16.6.2'
                AND IDMSEXP = NEW.IDMSEXP
        ) <> 'ВС' THEN RAISE(ABORT, '[sql-debug] Серия полиса ВС!') --Серия полиса ЕП
        --(@F16.6.2#ЕП)and(@F16.7.1=3)
        WHEN NEW.MSE_END = 'Y'
        AND NEW.ELEMENT_NAME = '16.7.1'
        AND (NEW.ELEMENT_VALUE = '3')
        AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '16.6.2'
                AND IDMSEXP = NEW.IDMSEXP
        ) <> 'ЕП' THEN RAISE(ABORT, '[sql-debug] Серия полиса ЕП!')

        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '16.7.2')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет даты выдачи полиса')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '16.7.1')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Не выбран тип полиса')
        
        --В пункте 17.2.4  введите дату выдачи документа 
        WHEN NEW.MSE_END = 'Y'
        AND NEW.ELEMENT_NAME = '17.2.4'
        AND (
            NEW.ELEMENT_VALUE = ''
            OR NEW.ELEMENT_VALUE IS NULL
            OR NEW.ELEMENT_VALUE = ' '
        )
        AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '17.2.1'
                AND IDMSEXP = NEW.IDMSEXP
        ) <> '' THEN RAISE(ABORT, '[sql-debug] В пункте 17.2.4  введите дату выдачи документа !!') 
        
       --если 17.2.1 заполнен, 17.2.2 тоже должен быть заполнен
        WHEN NEW.MSE_END = 'Y'
        AND (NEW.ELEMENT_NAME = '17.2.2.1' OR NEW.ELEMENT_NAME = '17.2.2.2') 
        AND (
            NEW.ELEMENT_VALUE = ''
            OR NEW.ELEMENT_VALUE IS NULL
            OR NEW.ELEMENT_VALUE = ' '
        )
        AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '17.2.1'
                AND IDMSEXP = NEW.IDMSEXP
        ) <> '' THEN RAISE(
            ABORT,
            '[sql-debug] В пункте 17.2.2  должна быть введена серия и номер документа!'
        ) 

        --В пункте 17.3.4  введите дату выдачи документа
        --(@F17.3.1#)and(@F17.3.4=)
        WHEN NEW.MSE_END = 'Y'
        AND NEW.ELEMENT_NAME = '17.3.4'
        AND (
            NEW.ELEMENT_VALUE = ''
            OR NEW.ELEMENT_VALUE IS NULL
            OR NEW.ELEMENT_VALUE = ' '
        )
        AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '17.3.1'
                AND IDMSEXP = NEW.IDMSEXP
        ) <> '' THEN RAISE(
            ABORT,
            '[sql-debug] В пункте 17.3.4  введите дату выдачи документа !'
        )         


        WHEN (
            NEW.MSE_END = 'Y'
            AND NEW.ELEMENT_NAME = '22'
            AND (
                new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;' OR 
                NEW.ELEMENT_VALUE <> CAST(NEW.ELEMENT_VALUE AS INT) OR
                CAST(NEW.ELEMENT_VALUE AS INT) < 1000 OR 
                CAST(NEW.ELEMENT_VALUE AS INT) > CAST(substr(date('now'),1, 4) AS INT) OR
                SUBSTR(date(), 1, 4) < CAST(NEW.ELEMENT_VALUE AS INT)
            )
        ) THEN RAISE(
            ABORT,
            '[sql-debug] В пункте 23 должен быть только год из 4 цифр (не может быть будущим)!'
        )

        --Количество дней нетрудоспособности должно быть целым числом
        WHEN (NEW.MSE_END = 'Y')
        AND (
            NEW.ELEMENT_NAME = '25.01.03'
            OR NEW.ELEMENT_NAME = '25.02.03'
            OR NEW.ELEMENT_NAME = '25.03.03'
            OR NEW.ELEMENT_NAME = '25.04.03'
            OR NEW.ELEMENT_NAME = '25.05.03'
        )
        AND (
            new.ELEMENT_VALUE <> '' AND 
            new.ELEMENT_VALUE = ' ' AND 
            new.ELEMENT_VALUE = '&nbsp;' AND  
            NEW.ELEMENT_VALUE <> CAST(NEW.ELEMENT_VALUE AS INT)
        ) THEN RAISE(
            ABORT,
            '[sql-debug] Количество дней нетрудоспособности (подпункты п. 26) должно быть целым числом!'
        ) 

         --В пункте 26 в номере не должно быть тире
        WHEN (NEW.MSE_END = 'Y')
        AND NEW.ELEMENT_NAME = '26.0.1'
        AND NEW.ELEMENT_VALUE LIKE '%-%' THEN RAISE(
            ABORT,
            '[sql-debug] В пункте 27 в номере не должно быть тире!'
        ) --В пункте 26 в протоколе МСЭ не должно быть тире
        WHEN (NEW.MSE_END = 'Y')
        AND NEW.ELEMENT_NAME = '26.0.2'
        AND NEW.ELEMENT_VALUE LIKE '%-%' THEN RAISE(
            ABORT,
            '[sql-debug] В пункте 27 в протоколе МСЭ не должно быть тире!'
        ) 
        

        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '27.1')
            AND (new.ELEMENT_VALUE = '' OR 
                 new.ELEMENT_VALUE = ' ' OR 
                 new.ELEMENT_VALUE = '&nbsp;' OR 
                 NEW.ELEMENT_VALUE <> CAST(NEW.ELEMENT_VALUE AS INT) OR
                 CAST(NEW.ELEMENT_VALUE AS INT) < 20 OR
                 CAST(NEW.ELEMENT_VALUE AS INT) > 220)
        ) THEN RAISE(ABORT, '[sql-debug] Рост (п. 28.1) должен быть целым числом от 20 до 220')
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '27.2')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;' OR
            NEW.ELEMENT_VALUE <> CAST(NEW.ELEMENT_VALUE AS INT) OR
            CAST(NEW.ELEMENT_VALUE AS INT) < 1 OR
            CAST(NEW.ELEMENT_VALUE AS INT) > 180)
        ) THEN RAISE(ABORT, '[sql-debug] Вес (п. 28.2) должен быть целым числом от 1 до 180')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '27.3')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;' OR 
            NEW.ELEMENT_VALUE <> CAST(NEW.ELEMENT_VALUE AS FLOAT))
        ) THEN RAISE(ABORT, '[sql-debug] Индекс массы тела (п. 28.2) должен быть числом!')
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '27.4')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет телосложения (п. 28.4)')
    

         WHEN (
            NEW.MSE_END = 'Y'
            AND NEW.ELEMENT_NAME = '27.5'
            AND (
                NEW.ELEMENT_VALUE <> CAST(NEW.ELEMENT_VALUE AS FLOAT) AND
                NEW.ELEMENT_VALUE <>'' AND 
                NEW.ELEMENT_VALUE <> ' ' AND 
                NEW.ELEMENT_VALUE <> '&nbsp;'
            )
        ) THEN RAISE(
            ABORT,
            '[sql-debug] Суточный объём физ. отправлений (п. 28.5) дожен быть числом!'
        )

        WHEN (
            NEW.MSE_END = 'Y'
            AND NEW.ELEMENT_NAME = '27.6'
            AND (
               (NEW.ELEMENT_VALUE <> '' AND 
                NEW.ELEMENT_VALUE <> ' ' AND
                NEW.ELEMENT_VALUE <>'&nbsp;' AND
                (NEW.ELEMENT_VALUE NOT GLOB '*/*' OR (CAST(REPLACE(NEW.ELEMENT_VALUE, '/','') AS INT) <> REPLACE(NEW.ELEMENT_VALUE, '/','')) )
                )
            )
        ) THEN RAISE(
            ABORT,
            '[sql-debug] Объем талии/бедер (п. 28.6) должны целыми быть числами, указанными через слэш!'
        )


         WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '30.2')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')	
        ) THEN RAISE(ABORT, '[sql-debug] Нет кода основного заболевания 31.2')

        WHEN NEW.MSE_END = 'Y' AND 
	((SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.1'
            AND IDMSEXP = NEW.IDMSEXP ) = '&nbsp;'
			OR 
		(SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.1'
            AND IDMSEXP = NEW.IDMSEXP) = ' ' OR (SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.1'
            AND IDMSEXP = NEW.IDMSEXP) = '')	
        AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.2'
            AND IDMSEXP = NEW.IDMSEXP
        ) <> '' 
		AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.2'
            AND IDMSEXP = NEW.IDMSEXP
        ) <> ''
		THEN RAISE(
            ABORT,
            '[sql-debug] Для основного диагноза не стоит описание (пункт 31.1)!'
        )
	
        
         WHEN NEW.MSE_END = 'Y' AND 
		((SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.3'
            AND IDMSEXP = NEW.IDMSEXP ) = '&nbsp;'
			OR 
		(SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.3'
            AND IDMSEXP = NEW.IDMSEXP) = ' '
			OR
		(SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.3'
            AND IDMSEXP = NEW.IDMSEXP) = ''
			)	
        AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.3.1'
            AND IDMSEXP = NEW.IDMSEXP
        ) <> '' 
		AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.3.1'
            AND IDMSEXP = NEW.IDMSEXP
        ) <> ''
		THEN RAISE(
            ABORT,
            '[sql-debug] Заполните осложение основного заболевания (пункт 31.3)!'
        )    


          WHEN NEW.MSE_END = 'Y' AND 
	((SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.3.1'
            AND IDMSEXP = NEW.IDMSEXP ) = '&nbsp;'
			OR 
		(SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.3.1'
            AND IDMSEXP = NEW.IDMSEXP) = ' '
			OR
		(SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.3.1'
            AND IDMSEXP = NEW.IDMSEXP) = ''
			)	
        AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.3'
            AND IDMSEXP = NEW.IDMSEXP
        ) <> '' 
		AND (
            SELECT ELEMENT_VALUE
            FROM INFOMSEXP
            WHERE ELEMENT_NAME = '30.3'
            AND IDMSEXP = NEW.IDMSEXP
        ) <> ''
		THEN RAISE(
            ABORT,
            '[sql-debug] Для осложнения основного диагноза не стоит код МКБ (пункт 31.3.1)!'
        )
        
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '38')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(
            ABORT,
            '[sql-debug] Нет председателя врачебной комисси (подпункт п. 40)'
        )

		WHEN --ТУТ дата выдачи направления на мед соц экспертизу - '01.02'
        (
            NEW.MSE_END = 'Y' AND
            NEW.ELEMENT_NAME = '04.0' AND
            (julianday(DATE('now', 'localtime')) - julianday(DATE(SUBSTR(NEW.ELEMENT_VALUE, 7, 4) || '-' || SUBSTR(NEW.ELEMENT_VALUE, 4, 2) || '-' || SUBSTR(NEW.ELEMENT_VALUE, 1, 2))) < 0 OR
            (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;'))
        ) THEN RAISE(ABORT, '[sql-debug] Дата выдачи направления на медсоцэкспертизу (п. 04.0) не может пустой или будущей!')

        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '42D')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(ABORT, '[sql-debug] Нет лечащего врача (подпункт п. 40)')        

            
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = '119.1')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(
            ABORT,
            '[sql-debug] Не указана дата взятия согласия пациента (п. 19.1)'
        )
		
		
        WHEN (
            (new.MSE_END = 'Y')
            AND (new.ELEMENT_NAME = 'R119.2')
            AND (new.ELEMENT_VALUE = '' OR new.ELEMENT_VALUE = ' ' OR new.ELEMENT_VALUE = '&nbsp;')
        ) THEN RAISE(
            ABORT,
            '[sql-debug] Не выбрана форма проведения МСЭ (п. 19.2)'
        ) --время не может быть будущим
        

        	
    WHEN (
            (NEW.MSE_END = 'Y')       
            AND (
                SELECT COUNT(*)
                FROM INFOMSEXP
                WHERE IDMSEXP = NEW.IDMSEXP
                    AND (ELEMENT_VALUE = '' OR ELEMENT_VALUE = ' ' OR ELEMENT_VALUE IS NULL)  
                    AND (ELEMENT_NAME = '119.3.1'
                    OR ELEMENT_NAME = '119.3.2'
                    OR ELEMENT_NAME = '119.3.3'
                    )
            ) = 3
        ) THEN RAISE(
            ABORT,
            '[sql-debug] В пункте 19.3 должен быть выбран один вариант!'
        )
		
		
	--PREPARATS
	WHEN
	(NEW.MSE_END = 'Y') AND 
	((SELECT INFOPREPARAT FROM PREPARATS WHERE PREPARATS.IDMSEXP = NEW.IDMSEXP) IS NULL OR 
	 (SELECT INFOPREPARAT FROM PREPARATS WHERE PREPARATS.IDMSEXP = NEW.IDMSEXP) = '' OR 
	 (SELECT INFOPREPARAT FROM PREPARATS WHERE PREPARATS.IDMSEXP = NEW.IDMSEXP) = ' ' OR 
	 (SELECT INFOPREPARAT FROM PREPARATS WHERE PREPARATS.IDMSEXP = NEW.IDMSEXP) = '&nbsp;' OR
	 (SELECT COUNT(INFOPREPARAT) FROM PREPARATS WHERE PREPARATS.IDMSEXP = NEW.IDMSEXP) = 0 OR 
	 (SELECT COUNT(infopreparat) FROM PREPARATS WHERE 
	 (infopreparat LIKE '%[{ "CODEPREPARAT" : ""%'  OR infopreparat LIKE '%"NAMEPREPARAT" : "" }]%') AND PREPARATS.IDMSEXP = NEW.IDMSEXP) <> 0
	)
	THEN RAISE(
        ABORT,
        '[sql-debug] Раздел "Препараты" заполнен некорректно!'
    )
		
    END; END;
    





