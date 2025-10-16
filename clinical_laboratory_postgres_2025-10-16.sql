--
-- PostgreSQL database dump
--

\restrict zvIgAYAzdvgp2hhjCF6ZZ4I95AUlPTPbFfH4iKQbz4WP2JvXhJIeTrgeT8ecUpO

-- Dumped from database version 16.10 (Debian 16.10-1.pgdg13+1)
-- Dumped by pg_dump version 16.10 (Debian 16.10-1.pgdg13+1)

-- Started on 2025-10-16 13:37:19 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 929 (class 1247 OID 106520)
-- Name: data_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.data_type_enum AS ENUM (
    'Numeric',
    'Text',
    'Boolean'
);


ALTER TYPE public.data_type_enum OWNER TO postgres;

--
-- TOC entry 983 (class 1247 OID 139266)
-- Name: doctors_audit_action; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.doctors_audit_action AS ENUM (
    'UPDATE',
    'DELETE',
    'INSERT'
);


ALTER TYPE public.doctors_audit_action OWNER TO postgres;

--
-- TOC entry 995 (class 1247 OID 139326)
-- Name: lab_orders_audit_action; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.lab_orders_audit_action AS ENUM (
    'UPDATE',
    'DELETE',
    'INSERT'
);


ALTER TYPE public.lab_orders_audit_action OWNER TO postgres;

--
-- TOC entry 923 (class 1247 OID 106506)
-- Name: order_priority_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_priority_type AS ENUM (
    'Normal',
    'Urgent'
);


ALTER TYPE public.order_priority_type OWNER TO postgres;

--
-- TOC entry 926 (class 1247 OID 106512)
-- Name: order_status_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status_type AS ENUM (
    'Pending',
    'In_Progress',
    'Reported'
);


ALTER TYPE public.order_status_type OWNER TO postgres;

--
-- TOC entry 989 (class 1247 OID 139296)
-- Name: patients_audit_action; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.patients_audit_action AS ENUM (
    'UPDATE',
    'DELETE',
    'INSERT'
);


ALTER TYPE public.patients_audit_action OWNER TO postgres;

--
-- TOC entry 938 (class 1247 OID 106544)
-- Name: payment_method_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_method_type AS ENUM (
    'Cash',
    'Card',
    'Transfer',
    'Insurance'
);


ALTER TYPE public.payment_method_type OWNER TO postgres;

--
-- TOC entry 941 (class 1247 OID 106554)
-- Name: payment_status_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status_type AS ENUM (
    'Pending',
    'Completed',
    'Rejected'
);


ALTER TYPE public.payment_status_type OWNER TO postgres;

--
-- TOC entry 1013 (class 1247 OID 139416)
-- Name: payments_audit_action; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payments_audit_action AS ENUM (
    'UPDATE',
    'DELETE',
    'INSERT'
);


ALTER TYPE public.payments_audit_action OWNER TO postgres;

--
-- TOC entry 935 (class 1247 OID 106538)
-- Name: policy_status_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.policy_status_type AS ENUM (
    'Active',
    'Expired'
);


ALTER TYPE public.policy_status_type OWNER TO postgres;

--
-- TOC entry 1007 (class 1247 OID 139386)
-- Name: results_audit_action; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.results_audit_action AS ENUM (
    'UPDATE',
    'DELETE',
    'INSERT'
);


ALTER TYPE public.results_audit_action OWNER TO postgres;

--
-- TOC entry 932 (class 1247 OID 106528)
-- Name: sample_status_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sample_status_type AS ENUM (
    'Collected',
    'In_Progress',
    'Used',
    'Discarded'
);


ALTER TYPE public.sample_status_type OWNER TO postgres;

--
-- TOC entry 1001 (class 1247 OID 139356)
-- Name: samples_audit_action; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.samples_audit_action AS ENUM (
    'UPDATE',
    'DELETE',
    'INSERT'
);


ALTER TYPE public.samples_audit_action OWNER TO postgres;

--
-- TOC entry 920 (class 1247 OID 106498)
-- Name: sex_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sex_type AS ENUM (
    'M',
    'F',
    'Other'
);


ALTER TYPE public.sex_type OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 139283)
-- Name: doctors_ai_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.doctors_ai_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_doctors_trigger','1', true);

  INSERT INTO doctors_audit (doctor_id, action_doctor, before_data, after_data)
  VALUES (
    NEW.id,
    'INSERT',
    NULL,
    jsonb_build_object(
      'id', NEW.id,
      'first_name', NEW.first_name,
      'last_name', NEW.last_name,
      'specialty', NEW.specialty,
      'phone', NEW.phone,
      'email', NEW.email
    )
  );

  PERFORM set_config('app.from_doctors_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.doctors_ai_audit() OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 139284)
-- Name: doctors_au_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.doctors_au_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_doctors_trigger','1', true);

  INSERT INTO doctors_audit (doctor_id, action_doctor, before_data, after_data)
  VALUES (
    NEW.id,
    'UPDATE',
    jsonb_build_object(
      'id', OLD.id,
      'first_name', OLD.first_name,
      'last_name', OLD.last_name,
      'specialty', OLD.specialty,
      'phone', OLD.phone,
      'email', OLD.email
    ),
    jsonb_build_object(
      'id', NEW.id,
      'first_name', NEW.first_name,
      'last_name', NEW.last_name,
      'specialty', NEW.specialty,
      'phone', NEW.phone,
      'email', NEW.email
    )
  );

  PERFORM set_config('app.from_doctors_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.doctors_au_audit() OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 139291)
-- Name: doctors_audit_block_bd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.doctors_audit_block_bd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'doctors_audit es inmutable: DELETE prohibido.';
  RETURN OLD;
END$$;


ALTER FUNCTION public.doctors_audit_block_bd() OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 139290)
-- Name: doctors_audit_block_bu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.doctors_audit_block_bu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'doctors_audit es inmutable: UPDATE prohibido.';
  RETURN NEW;
END$$;


ALTER FUNCTION public.doctors_audit_block_bu() OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 139289)
-- Name: doctors_audit_guard_bi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.doctors_audit_guard_bi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  flag text;
BEGIN
  flag := current_setting('app.from_doctors_trigger', true);
  IF COALESCE(flag, '0') <> '1' THEN
    RAISE EXCEPTION 'INSERT en doctors_audit solo permitido desde triggers de doctors.';
  END IF;
  RETURN NEW;
END$$;


ALTER FUNCTION public.doctors_audit_guard_bi() OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 139285)
-- Name: doctors_bd_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.doctors_bd_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_doctors_trigger','1', true);

  INSERT INTO doctors_audit (doctor_id, action_doctor, before_data, after_data)
  VALUES (
    OLD.id,
    'DELETE',
    jsonb_build_object(
      'id', OLD.id,
      'first_name', OLD.first_name,
      'last_name', OLD.last_name,
      'specialty', OLD.specialty,
      'phone', OLD.phone,
      'email', OLD.email
    ),
    NULL
  );

  PERFORM set_config('app.from_doctors_trigger','', true);
  RETURN OLD;
END$$;


ALTER FUNCTION public.doctors_bd_audit() OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 131075)
-- Name: fn_relacion_clasica_postgres(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_relacion_clasica_postgres() RETURNS TABLE(first_name text, last_name text, lab_order_id integer, sample_id integer, value numeric, result_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT P.first_name, P.last_name, L.id, S.id, R.value, R.result_date
  FROM patients P, lab_orders L, samples S, results R
  WHERE P.id = L.patient_id AND L.id = S.lab_order_id AND S.id = R.sample_id;
END;
$$;


ALTER FUNCTION public.fn_relacion_clasica_postgres() OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 131076)
-- Name: fn_relacion_join_postgres(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_relacion_join_postgres() RETURNS TABLE(first_name text, last_name text, lab_order_id integer, sample_id integer, value numeric, result_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT P.first_name, P.last_name, L.id, S.id, R.value, R.result_date
  FROM patients P
  JOIN lab_orders L ON P.id = L.patient_id
  JOIN samples S ON L.id = S.lab_order_id
  JOIN results R ON S.id = R.sample_id;
END;
$$;


ALTER FUNCTION public.fn_relacion_join_postgres() OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 131077)
-- Name: fn_relacion_por_paciente_postgres(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_relacion_por_paciente_postgres(paciente_id integer) RETURNS TABLE(first_name text, last_name text, lab_order_id integer, sample_id integer, value numeric, result_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT P.first_name, P.last_name, L.id, S.id, R.value, R.result_date
  FROM patients P
  JOIN lab_orders L ON P.id = L.patient_id
  JOIN samples S ON L.id = S.lab_order_id
  JOIN results R ON S.id = R.sample_id
  WHERE P.id = paciente_id;
END;
$$;


ALTER FUNCTION public.fn_relacion_por_paciente_postgres(paciente_id integer) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 131079)
-- Name: fn_resultados_por_apellido_postgres(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_resultados_por_apellido_postgres(prefijo text) RETURNS TABLE(first_name text, last_name text, lab_order_id integer, sample_id integer, value numeric, result_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT P.first_name, P.last_name, L.id, S.id, R.value, R.result_date
  FROM patients P
  JOIN lab_orders L ON P.id = L.patient_id
  JOIN samples S ON L.id = S.lab_order_id
  JOIN results R ON S.id = R.sample_id
  WHERE P.last_name ILIKE prefijo || '%';
END;
$$;


ALTER FUNCTION public.fn_resultados_por_apellido_postgres(prefijo text) OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 131078)
-- Name: fn_resultados_por_rango_postgres(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_resultados_por_rango_postgres(fecha_inicio date, fecha_fin date) RETURNS TABLE(first_name text, last_name text, lab_order_id integer, sample_id integer, value numeric, result_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT P.first_name, P.last_name, L.id, S.id, R.value, R.result_date
  FROM patients P
  JOIN lab_orders L ON P.id = L.patient_id
  JOIN samples S ON L.id = S.lab_order_id
  JOIN results R ON S.id = R.sample_id
  WHERE R.result_date BETWEEN fecha_inicio AND fecha_fin;
END;
$$;


ALTER FUNCTION public.fn_resultados_por_rango_postgres(fecha_inicio date, fecha_fin date) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 139343)
-- Name: lab_orders_ai_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lab_orders_ai_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_lab_orders_trigger','1', true);

  INSERT INTO lab_orders_audit (order_id, action_order, before_data, after_data)
  VALUES (
    NEW.id,
    'INSERT',
    NULL,
    jsonb_build_object(
      'id', NEW.id,
      'patient_id', NEW.patient_id,
      'doctor_id', NEW.doctor_id,
      'order_date', NEW.order_date,
      'priority', NEW.priority,
      'status', NEW.status,
      'notes', NEW.notes
    )
  );

  PERFORM set_config('app.from_lab_orders_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.lab_orders_ai_audit() OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 139344)
-- Name: lab_orders_au_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lab_orders_au_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_lab_orders_trigger','1', true);

  INSERT INTO lab_orders_audit (order_id, action_order, before_data, after_data)
  VALUES (
    NEW.id,
    'UPDATE',
    jsonb_build_object(
      'id', OLD.id,
      'patient_id', OLD.patient_id,
      'doctor_id', OLD.doctor_id,
      'order_date', OLD.order_date,
      'priority', OLD.priority,
      'status', OLD.status,
      'notes', OLD.notes
    ),
    jsonb_build_object(
      'id', NEW.id,
      'patient_id', NEW.patient_id,
      'doctor_id', NEW.doctor_id,
      'order_date', NEW.order_date,
      'priority', NEW.priority,
      'status', NEW.status,
      'notes', NEW.notes
    )
  );

  PERFORM set_config('app.from_lab_orders_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.lab_orders_au_audit() OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 139351)
-- Name: lab_orders_audit_block_bd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lab_orders_audit_block_bd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'lab_orders_audit es inmutable: DELETE prohibido.';
  RETURN OLD;
END$$;


ALTER FUNCTION public.lab_orders_audit_block_bd() OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 139350)
-- Name: lab_orders_audit_block_bu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lab_orders_audit_block_bu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'lab_orders_audit es inmutable: UPDATE prohibido.';
  RETURN NEW;
END$$;


ALTER FUNCTION public.lab_orders_audit_block_bu() OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 139349)
-- Name: lab_orders_audit_guard_bi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lab_orders_audit_guard_bi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  flag text;
BEGIN
  flag := current_setting('app.from_lab_orders_trigger', true);
  IF COALESCE(flag, '0') <> '1' THEN
    RAISE EXCEPTION 'INSERT en lab_orders_audit solo permitido desde triggers de lab_orders.';
  END IF;
  RETURN NEW;
END$$;


ALTER FUNCTION public.lab_orders_audit_guard_bi() OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 139345)
-- Name: lab_orders_bd_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lab_orders_bd_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_lab_orders_trigger','1', true);

  INSERT INTO lab_orders_audit (order_id, action_order, before_data, after_data)
  VALUES (
    OLD.id,
    'DELETE',
    jsonb_build_object(
      'id', OLD.id,
      'patient_id', OLD.patient_id,
      'doctor_id', OLD.doctor_id,
      'order_date', OLD.order_date,
      'priority', OLD.priority,
      'status', OLD.status,
      'notes', OLD.notes
    ),
    NULL
  );

  PERFORM set_config('app.from_lab_orders_trigger','', true);
  RETURN OLD;
END$$;


ALTER FUNCTION public.lab_orders_bd_audit() OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 139313)
-- Name: patients_ai_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.patients_ai_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_patients_trigger','1', true);

  INSERT INTO patients_audit (patient_id, action_patient, before_data, after_data)
  VALUES (
    NEW.id,
    'INSERT',
    NULL,
    jsonb_build_object(
      'id', NEW.id,
      'first_name', NEW.first_name,
      'last_name', NEW.last_name,
      'document_number', NEW.document_number,
      'birth_date', NEW.birth_date,
      'sex', NEW.sex,
      'address', NEW.address,
      'phone', NEW.phone,
      'email', NEW.email
    )
  );

  PERFORM set_config('app.from_patients_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.patients_ai_audit() OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 139314)
-- Name: patients_au_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.patients_au_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_patients_trigger','1', true);

  INSERT INTO patients_audit (patient_id, action_patient, before_data, after_data)
  VALUES (
    NEW.id,
    'UPDATE',
    jsonb_build_object(
      'id', OLD.id,
      'first_name', OLD.first_name,
      'last_name', OLD.last_name,
      'document_number', OLD.document_number,
      'birth_date', OLD.birth_date,
      'sex', OLD.sex,
      'address', OLD.address,
      'phone', OLD.phone,
      'email', OLD.email
    ),
    jsonb_build_object(
      'id', NEW.id,
      'first_name', NEW.first_name,
      'last_name', NEW.last_name,
      'document_number', NEW.document_number,
      'birth_date', NEW.birth_date,
      'sex', NEW.sex,
      'address', NEW.address,
      'phone', NEW.phone,
      'email', NEW.email
    )
  );

  PERFORM set_config('app.from_patients_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.patients_au_audit() OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 139321)
-- Name: patients_audit_block_bd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.patients_audit_block_bd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'patients_audit es inmutable: DELETE prohibido.';
  RETURN OLD;
END$$;


ALTER FUNCTION public.patients_audit_block_bd() OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 139320)
-- Name: patients_audit_block_bu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.patients_audit_block_bu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'patients_audit es inmutable: UPDATE prohibido.';
  RETURN NEW;
END$$;


ALTER FUNCTION public.patients_audit_block_bu() OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 139319)
-- Name: patients_audit_guard_bi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.patients_audit_guard_bi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  flag text;
BEGIN
  flag := current_setting('app.from_patients_trigger', true);
  IF COALESCE(flag, '0') <> '1' THEN
    RAISE EXCEPTION 'INSERT en patients_audit solo permitido desde triggers de patients.';
  END IF;
  RETURN NEW;
END$$;


ALTER FUNCTION public.patients_audit_guard_bi() OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 139315)
-- Name: patients_bd_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.patients_bd_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_patients_trigger','1', true);

  INSERT INTO patients_audit (patient_id, action_patient, before_data, after_data)
  VALUES (
    OLD.id,
    'DELETE',
    jsonb_build_object(
      'id', OLD.id,
      'first_name', OLD.first_name,
      'last_name', OLD.last_name,
      'document_number', OLD.document_number,
      'birth_date', OLD.birth_date,
      'sex', OLD.sex,
      'address', OLD.address,
      'phone', OLD.phone,
      'email', OLD.email
    ),
    NULL
  );

  PERFORM set_config('app.from_patients_trigger','', true);
  RETURN OLD;
END$$;


ALTER FUNCTION public.patients_bd_audit() OWNER TO postgres;

--
-- TOC entry 301 (class 1255 OID 139433)
-- Name: payments_ai_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.payments_ai_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_payments_trigger','1', true);

  INSERT INTO payments_audit (payment_id, action_payment, before_data, after_data)
  VALUES (
    NEW.id,
    'INSERT',
    NULL,
    jsonb_build_object(
      'id', NEW.id,
      'lab_order_id', NEW.lab_order_id,
      'amount', NEW.amount,
      'payment_date', NEW.payment_date,
      'payment_method', NEW.payment_method,
      'status', NEW.status
    )
  );

  PERFORM set_config('app.from_payments_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.payments_ai_audit() OWNER TO postgres;

--
-- TOC entry 302 (class 1255 OID 139434)
-- Name: payments_au_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.payments_au_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_payments_trigger','1', true);

  INSERT INTO payments_audit (payment_id, action_payment, before_data, after_data)
  VALUES (
    NEW.id,
    'UPDATE',
    jsonb_build_object(
      'id', OLD.id,
      'lab_order_id', OLD.lab_order_id,
      'amount', OLD.amount,
      'payment_date', OLD.payment_date,
      'payment_method', OLD.payment_method,
      'status', OLD.status
    ),
    jsonb_build_object(
      'id', NEW.id,
      'lab_order_id', NEW.lab_order_id,
      'amount', NEW.amount,
      'payment_date', NEW.payment_date,
      'payment_method', NEW.payment_method,
      'status', NEW.status
    )
  );

  PERFORM set_config('app.from_payments_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.payments_au_audit() OWNER TO postgres;

--
-- TOC entry 306 (class 1255 OID 139441)
-- Name: payments_audit_block_bd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.payments_audit_block_bd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'payments_audit es inmutable: DELETE prohibido.';
  RETURN OLD;
END$$;


ALTER FUNCTION public.payments_audit_block_bd() OWNER TO postgres;

--
-- TOC entry 305 (class 1255 OID 139440)
-- Name: payments_audit_block_bu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.payments_audit_block_bu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'payments_audit es inmutable: UPDATE prohibido.';
  RETURN NEW;
END$$;


ALTER FUNCTION public.payments_audit_block_bu() OWNER TO postgres;

--
-- TOC entry 304 (class 1255 OID 139439)
-- Name: payments_audit_guard_bi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.payments_audit_guard_bi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  flag text;
BEGIN
  flag := current_setting('app.from_payments_trigger', true);
  IF COALESCE(flag, '0') <> '1' THEN
    RAISE EXCEPTION 'INSERT en payments_audit solo permitido desde triggers de payments.';
  END IF;
  RETURN NEW;
END$$;


ALTER FUNCTION public.payments_audit_guard_bi() OWNER TO postgres;

--
-- TOC entry 303 (class 1255 OID 139435)
-- Name: payments_bd_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.payments_bd_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_payments_trigger','1', true);

  INSERT INTO payments_audit (payment_id, action_payment, before_data, after_data)
  VALUES (
    OLD.id,
    'DELETE',
    jsonb_build_object(
      'id', OLD.id,
      'lab_order_id', OLD.lab_order_id,
      'amount', OLD.amount,
      'payment_date', OLD.payment_date,
      'payment_method', OLD.payment_method,
      'status', OLD.status
    ),
    NULL
  );

  PERFORM set_config('app.from_payments_trigger','', true);
  RETURN OLD;
END$$;


ALTER FUNCTION public.payments_bd_audit() OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 139403)
-- Name: results_ai_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.results_ai_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_results_trigger','1', true);

  INSERT INTO results_audit (result_id, action_result, before_data, after_data)
  VALUES (
    NEW.id,
    'INSERT',
    NULL,
    jsonb_build_object(
      'id', NEW.id,
      'sample_id', NEW.sample_id,
      'parameter_id', NEW.parameter_id,
      'result_value', NEW.result_value,
      'result_date', NEW.result_date,
      'doctor_id', NEW.doctor_id
    )
  );

  PERFORM set_config('app.from_results_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.results_ai_audit() OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 139404)
-- Name: results_au_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.results_au_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_results_trigger','1', true);

  INSERT INTO results_audit (result_id, action_result, before_data, after_data)
  VALUES (
    NEW.id,
    'UPDATE',
    jsonb_build_object(
      'id', OLD.id,
      'sample_id', OLD.sample_id,
      'parameter_id', OLD.parameter_id,
      'result_value', OLD.result_value,
      'result_date', OLD.result_date,
      'doctor_id', OLD.doctor_id
    ),
    jsonb_build_object(
      'id', NEW.id,
      'sample_id', NEW.sample_id,
      'parameter_id', NEW.parameter_id,
      'result_value', NEW.result_value,
      'result_date', NEW.result_date,
      'doctor_id', NEW.doctor_id
    )
  );

  PERFORM set_config('app.from_results_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.results_au_audit() OWNER TO postgres;

--
-- TOC entry 300 (class 1255 OID 139411)
-- Name: results_audit_block_bd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.results_audit_block_bd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'results_audit es inmutable: DELETE prohibido.';
  RETURN OLD;
END$$;


ALTER FUNCTION public.results_audit_block_bd() OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 139410)
-- Name: results_audit_block_bu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.results_audit_block_bu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'results_audit es inmutable: UPDATE prohibido.';
  RETURN NEW;
END$$;


ALTER FUNCTION public.results_audit_block_bu() OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 139409)
-- Name: results_audit_guard_bi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.results_audit_guard_bi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  flag text;
BEGIN
  flag := current_setting('app.from_results_trigger', true);
  IF COALESCE(flag, '0') <> '1' THEN
    RAISE EXCEPTION 'INSERT en results_audit solo permitido desde triggers de results.';
  END IF;
  RETURN NEW;
END$$;


ALTER FUNCTION public.results_audit_guard_bi() OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 139405)
-- Name: results_bd_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.results_bd_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_results_trigger','1', true);

  INSERT INTO results_audit (result_id, action_result, before_data, after_data)
  VALUES (
    OLD.id,
    'DELETE',
    jsonb_build_object(
      'id', OLD.id,
      'sample_id', OLD.sample_id,
      'parameter_id', OLD.parameter_id,
      'result_value', OLD.result_value,
      'result_date', OLD.result_date,
      'doctor_id', OLD.doctor_id
    ),
    NULL
  );

  PERFORM set_config('app.from_results_trigger','', true);
  RETURN OLD;
END$$;


ALTER FUNCTION public.results_bd_audit() OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 139373)
-- Name: samples_ai_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.samples_ai_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_samples_trigger','1', true);

  INSERT INTO samples_audit (sample_id, action_sample, before_data, after_data)
  VALUES (
    NEW.id,
    'INSERT',
    NULL,
    jsonb_build_object(
      'id', NEW.id,
      'lab_order_id', NEW.lab_order_id,
      'type', NEW.type,
      'collected_at', NEW.collected_at,
      'status', NEW.status,
      'notes', NEW.notes
    )
  );

  PERFORM set_config('app.from_samples_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.samples_ai_audit() OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 139374)
-- Name: samples_au_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.samples_au_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_samples_trigger','1', true);

  INSERT INTO samples_audit (sample_id, action_sample, before_data, after_data)
  VALUES (
    NEW.id,
    'UPDATE',
    jsonb_build_object(
      'id', OLD.id,
      'lab_order_id', OLD.lab_order_id,
      'type', OLD.type,
      'collected_at', OLD.collected_at,
      'status', OLD.status,
      'notes', OLD.notes
    ),
    jsonb_build_object(
      'id', NEW.id,
      'lab_order_id', NEW.lab_order_id,
      'type', NEW.type,
      'collected_at', NEW.collected_at,
      'status', NEW.status,
      'notes', NEW.notes
    )
  );

  PERFORM set_config('app.from_samples_trigger','', true);
  RETURN NEW;
END$$;


ALTER FUNCTION public.samples_au_audit() OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 139381)
-- Name: samples_audit_block_bd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.samples_audit_block_bd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'samples_audit es inmutable: DELETE prohibido.';
  RETURN OLD;
END$$;


ALTER FUNCTION public.samples_audit_block_bd() OWNER TO postgres;

--
-- TOC entry 293 (class 1255 OID 139380)
-- Name: samples_audit_block_bu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.samples_audit_block_bu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE EXCEPTION 'samples_audit es inmutable: UPDATE prohibido.';
  RETURN NEW;
END$$;


ALTER FUNCTION public.samples_audit_block_bu() OWNER TO postgres;

--
-- TOC entry 292 (class 1255 OID 139379)
-- Name: samples_audit_guard_bi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.samples_audit_guard_bi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  flag text;
BEGIN
  flag := current_setting('app.from_samples_trigger', true);
  IF COALESCE(flag, '0') <> '1' THEN
    RAISE EXCEPTION 'INSERT en samples_audit solo permitido desde triggers de samples.';
  END IF;
  RETURN NEW;
END$$;


ALTER FUNCTION public.samples_audit_guard_bi() OWNER TO postgres;

--
-- TOC entry 291 (class 1255 OID 139375)
-- Name: samples_bd_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.samples_bd_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM set_config('app.from_samples_trigger','1', true);

  INSERT INTO samples_audit (sample_id, action_sample, before_data, after_data)
  VALUES (
    OLD.id,
    'DELETE',
    jsonb_build_object(
      'id', OLD.id,
      'lab_order_id', OLD.lab_order_id,
      'type', OLD.type,
      'collected_at', OLD.collected_at,
      'status', OLD.status,
      'notes', OLD.notes
    ),
    NULL
  );

  PERFORM set_config('app.from_samples_trigger','', true);
  RETURN OLD;
END$$;


ALTER FUNCTION public.samples_bd_audit() OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 122881)
-- Name: sp_relacion_clasica_postgres(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_relacion_clasica_postgres()
    LANGUAGE plpgsql
    AS $$
BEGIN
  RAISE NOTICE 'Resultados:';
  PERFORM P.first_name, P.last_name, L.id, S.id, R.value, R.result_date
  FROM patients P, lab_orders L, samples S, results R
  WHERE P.id = L.patient_id
    AND L.id = S.lab_order_id
    AND S.id = R.sample_id;
END;
$$;


ALTER PROCEDURE public.sp_relacion_clasica_postgres() OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 122882)
-- Name: sp_relacion_join_postgres(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_relacion_join_postgres()
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM P.first_name, P.last_name, L.id, S.id, R.value, R.result_date
  FROM patients P
  JOIN lab_orders L ON P.id = L.patient_id
  JOIN samples S ON L.id = S.lab_order_id
  JOIN results R ON S.id = R.sample_id;
END;
$$;


ALTER PROCEDURE public.sp_relacion_join_postgres() OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 122883)
-- Name: sp_relacion_por_paciente_postgres(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_relacion_por_paciente_postgres(IN paciente_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM P.first_name, P.last_name, L.id, S.id, R.value, R.result_date
  FROM patients P
  JOIN lab_orders L ON P.id = L.patient_id
  JOIN samples S ON L.id = S.lab_order_id
  JOIN results R ON S.id = R.sample_id
  WHERE P.id = paciente_id;
END;
$$;


ALTER PROCEDURE public.sp_relacion_por_paciente_postgres(IN paciente_id integer) OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 122884)
-- Name: sp_resultados_por_apellido_postgres(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_resultados_por_apellido_postgres(IN prefijo character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM P.first_name, P.last_name, L.id, S.id, R.value, R.result_date
  FROM patients P
  JOIN lab_orders L ON P.id = L.patient_id
  JOIN samples S ON L.id = S.lab_order_id
  JOIN results R ON S.id = R.sample_id
  WHERE P.last_name ILIKE prefijo || '%';
END;
$$;


ALTER PROCEDURE public.sp_resultados_por_apellido_postgres(IN prefijo character varying) OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 122885)
-- Name: sp_resultados_por_rango_postgres(date, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_resultados_por_rango_postgres(IN fecha_inicio date, IN fecha_fin date)
    LANGUAGE plpgsql
    AS $$
BEGIN
  PERFORM P.first_name, P.last_name, L.id, S.id, R.value, R.result_date
  FROM patients P
  JOIN lab_orders L ON P.id = L.patient_id
  JOIN samples S ON L.id = S.lab_order_id
  JOIN results R ON S.id = R.sample_id
  WHERE R.result_date BETWEEN fecha_inicio AND fecha_fin;
END;
$$;


ALTER PROCEDURE public.sp_resultados_por_rango_postgres(IN fecha_inicio date, IN fecha_fin date) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 106578)
-- Name: doctors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctors (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    specialty character varying(100),
    phone character varying(50),
    email character varying(100)
);


ALTER TABLE public.doctors OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 139274)
-- Name: doctors_audit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctors_audit (
    audit_id bigint NOT NULL,
    doctor_id bigint NOT NULL,
    action_doctor public.doctors_audit_action NOT NULL,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    changed_by text DEFAULT 'Admin'::text NOT NULL,
    before_data jsonb,
    after_data jsonb
);


ALTER TABLE public.doctors_audit OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 139273)
-- Name: doctors_audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.doctors_audit ALTER COLUMN audit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.doctors_audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 106577)
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.doctors ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.doctors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 106572)
-- Name: insurers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insurers (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    phone character varying(50),
    email character varying(100)
);


ALTER TABLE public.insurers OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 106571)
-- Name: insurers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.insurers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.insurers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 106660)
-- Name: insurers_patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insurers_patients (
    patient_id integer NOT NULL,
    insurer_id integer NOT NULL,
    policy_number character varying(50) NOT NULL,
    status public.policy_status_type DEFAULT 'Active'::public.policy_status_type,
    start_date date,
    end_date date
);


ALTER TABLE public.insurers_patients OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 106600)
-- Name: lab_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_orders (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    doctor_id integer,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    priority public.order_priority_type DEFAULT 'Normal'::public.order_priority_type,
    status public.order_status_type DEFAULT 'Pending'::public.order_status_type,
    notes text
);


ALTER TABLE public.lab_orders OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 139334)
-- Name: lab_orders_audit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_orders_audit (
    audit_id bigint NOT NULL,
    order_id bigint NOT NULL,
    action_order public.lab_orders_audit_action NOT NULL,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    changed_by text DEFAULT 'Admin'::text NOT NULL,
    before_data jsonb,
    after_data jsonb
);


ALTER TABLE public.lab_orders_audit OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 139333)
-- Name: lab_orders_audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.lab_orders_audit ALTER COLUMN audit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lab_orders_audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 106599)
-- Name: lab_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.lab_orders ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lab_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 106691)
-- Name: lab_orders_tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_orders_tests (
    lab_order_id integer NOT NULL,
    test_id integer NOT NULL
);


ALTER TABLE public.lab_orders_tests OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 106584)
-- Name: panels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.panels (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    estimated_time integer,
    cost numeric(10,2)
);


ALTER TABLE public.panels OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 106583)
-- Name: panels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.panels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.panels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 106676)
-- Name: panels_tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.panels_tests (
    panel_id integer NOT NULL,
    test_id integer NOT NULL
);


ALTER TABLE public.panels_tests OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 106621)
-- Name: parameters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parameters (
    id integer NOT NULL,
    test_id integer NOT NULL,
    name character varying(100) NOT NULL,
    unit character varying(50),
    reference_values character varying(100),
    data_type public.data_type_enum DEFAULT 'Text'::public.data_type_enum
);


ALTER TABLE public.parameters OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 106620)
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 106562)
-- Name: patients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patients (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    document_number character varying(50) NOT NULL,
    birth_date date,
    sex public.sex_type,
    address character varying(150),
    phone character varying(50),
    email character varying(100)
);


ALTER TABLE public.patients OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 139304)
-- Name: patients_audit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patients_audit (
    audit_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    action_patient public.patients_audit_action NOT NULL,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    changed_by text DEFAULT 'Admin'::text NOT NULL,
    before_data jsonb,
    after_data jsonb
);


ALTER TABLE public.patients_audit OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 139303)
-- Name: patients_audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.patients_audit ALTER COLUMN audit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.patients_audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 215 (class 1259 OID 106561)
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.patients ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 106648)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    lab_order_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    payment_method public.payment_method_type,
    status public.payment_status_type DEFAULT 'Pending'::public.payment_status_type
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 139424)
-- Name: payments_audit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments_audit (
    audit_id bigint NOT NULL,
    payment_id bigint NOT NULL,
    action_payment public.payments_audit_action NOT NULL,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    changed_by text DEFAULT 'Admin'::text NOT NULL,
    before_data jsonb,
    after_data jsonb
);


ALTER TABLE public.payments_audit OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 139423)
-- Name: payments_audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.payments_audit ALTER COLUMN audit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.payments_audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 106647)
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.payments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 106707)
-- Name: results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.results (
    id integer NOT NULL,
    sample_id integer NOT NULL,
    parameter_id integer NOT NULL,
    value character varying(100),
    result_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    doctor_id integer
);


ALTER TABLE public.results OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 139394)
-- Name: results_audit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.results_audit (
    audit_id bigint NOT NULL,
    result_id bigint NOT NULL,
    action_result public.results_audit_action NOT NULL,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    changed_by text DEFAULT 'Admin'::text NOT NULL,
    before_data jsonb,
    after_data jsonb
);


ALTER TABLE public.results_audit OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 139393)
-- Name: results_audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.results_audit ALTER COLUMN audit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.results_audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 106706)
-- Name: results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.results ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 106633)
-- Name: samples; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.samples (
    id integer NOT NULL,
    lab_order_id integer NOT NULL,
    type character varying(100),
    collected_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status public.sample_status_type DEFAULT 'Collected'::public.sample_status_type,
    notes text
);


ALTER TABLE public.samples OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 139364)
-- Name: samples_audit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.samples_audit (
    audit_id bigint NOT NULL,
    sample_id bigint NOT NULL,
    action_sample public.samples_audit_action NOT NULL,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    changed_by text DEFAULT 'Admin'::text NOT NULL,
    before_data jsonb,
    after_data jsonb
);


ALTER TABLE public.samples_audit OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 139363)
-- Name: samples_audit_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.samples_audit ALTER COLUMN audit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.samples_audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 106632)
-- Name: samples_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.samples ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.samples_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 106592)
-- Name: tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tests (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    sample_type character varying(100),
    estimated_time integer,
    cost numeric(10,2)
);


ALTER TABLE public.tests OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 106591)
-- Name: tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tests ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3702 (class 0 OID 106578)
-- Dependencies: 220
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctors (id, first_name, last_name, specialty, phone, email) FROM stdin;
2	Joseph	Perez	Pulmonology	+1-3200-351-1046	dr.joseph.perez2@clinic.org
3	Sarah	Martinez	Hematology	+1-3300-753-5106	dr.sarah.martinez3@clinic.org
4	Barbara	Davis	Infectious Disease	+1-3400-226-3159	dr.barbara.davis4@clinic.org
5	James	Thompson	Pulmonology	+1-3500-443-6304	dr.james.thompson5@clinic.org
6	Mary	Lopez	Microbiology	+1-3600-253-3076	dr.mary.lopez6@clinic.org
7	Melissa	Clark	Cardiology	+1-3700-316-2041	dr.melissa.clark7@clinic.org
8	Donald	Lewis	Pulmonology	+1-3800-570-9408	dr.donald.lewis8@clinic.org
10	Michelle	Williams	Gastroenterology	+1-3010-874-9543	dr.michelle.williams10@clinic.org
11	Karen	Robinson	Infectious Disease	+1-3110-231-1996	dr.karen.robinson11@clinic.org
12	Donald	Sanchez	Pediatrics	+1-3210-902-2768	dr.donald.sanchez12@clinic.org
13	Ashley	Rivera	Dermatology	+1-3310-654-2204	dr.ashley.rivera13@clinic.org
14	Jennifer	Lee	Nephrology	+1-3410-351-2076	dr.jennifer.lee14@clinic.org
15	William	Moore	Nephrology	+1-3510-848-9984	dr.william.moore15@clinic.org
16	Amanda	Lee	Pediatrics	+1-3610-811-9692	dr.amanda.lee16@clinic.org
17	Charles	Robinson	Cardiology	+1-3710-819-8048	dr.charles.robinson17@clinic.org
18	Michael	Hall	Internal Medicine	+1-3810-870-4522	dr.michael.hall18@clinic.org
19	Margaret	Lewis	Dermatology	+1-3910-433-7779	dr.margaret.lewis19@clinic.org
20	Nancy	Robinson	Pediatrics	+1-3020-625-2557	dr.nancy.robinson20@clinic.org
21	Christopher	Ramirez	Family Medicine	+1-3120-881-5176	dr.christopher.ramirez21@clinic.org
23	Jennifer	Garcia	Internal Medicine	+1-3320-642-2582	dr.jennifer.garcia23@clinic.org
24	Melissa	Mitchell	Family Medicine	+1-3420-333-1982	dr.melissa.mitchell24@clinic.org
25	Donna	Scott	Cardiology	+1-3520-537-3002	dr.donna.scott25@clinic.org
26	Anthony	Thompson	Rheumatology	+1-3620-881-7929	dr.anthony.thompson26@clinic.org
27	George	Brown	Microbiology	+1-3720-814-6119	dr.george.brown27@clinic.org
28	Daniel	Miller	Nephrology	+1-3820-719-4485	dr.daniel.miller28@clinic.org
29	Elizabeth	Nelson	Oncology	+1-3920-429-2773	dr.elizabeth.nelson29@clinic.org
30	Daniel	Scott	Family Medicine	+1-3030-317-5564	dr.daniel.scott30@clinic.org
31	Andrew	Anderson	Pulmonology	+1-3130-639-1430	dr.andrew.anderson31@clinic.org
32	Joshua	Nelson	Rheumatology	+1-3230-910-5381	dr.joshua.nelson32@clinic.org
33	Mary	Lopez	Microbiology	+1-3330-919-6062	dr.mary.lopez33@clinic.org
34	Nancy	Thompson	Pathology	+1-3430-385-3347	dr.nancy.thompson34@clinic.org
35	Andrew	Nelson	Pediatrics	+1-3530-271-3324	dr.andrew.nelson35@clinic.org
36	Melissa	Green	Pathology	+1-3630-293-9691	dr.melissa.green36@clinic.org
37	Susan	Harris	Pediatrics	+1-3730-664-6585	dr.susan.harris37@clinic.org
38	David	White	Microbiology	+1-3830-938-6314	dr.david.white38@clinic.org
39	Deborah	Torres	Nephrology	+1-3930-286-1861	dr.deborah.torres39@clinic.org
40	Elizabeth	Hernandez	Pulmonology	+1-3040-832-1815	dr.elizabeth.hernandez40@clinic.org
41	Carol	Garcia	Microbiology	+1-3140-653-7947	dr.carol.garcia41@clinic.org
42	Ashley	Hill	Oncology	+1-3240-624-5475	dr.ashley.hill42@clinic.org
43	Susan	Carter	Cardiology	+1-3340-316-6655	dr.susan.carter43@clinic.org
44	Margaret	Davis	Microbiology	+1-3440-894-8972	dr.margaret.davis44@clinic.org
45	Kimberly	Nelson	Microbiology	+1-3540-246-4612	dr.kimberly.nelson45@clinic.org
46	Betty	Hill	Pathology	+1-3640-207-4349	dr.betty.hill46@clinic.org
47	Karen	Wilson	Pulmonology	+1-3740-340-5186	dr.karen.wilson47@clinic.org
48	Charles	Lee	Internal Medicine	+1-3840-207-9149	dr.charles.lee48@clinic.org
49	Melissa	Ramirez	Hematology	+1-3940-332-7229	dr.melissa.ramirez49@clinic.org
50	Paul	Rivera	Endocrinology	+1-3050-712-6802	dr.paul.rivera50@clinic.org
51	John	Sanchez	Rheumatology	+1-3150-959-1693	dr.john.sanchez51@clinic.org
52	Margaret	Johnson	Oncology	+1-3250-279-6129	dr.margaret.johnson52@clinic.org
53	Andrew	Ramirez	Nephrology	+1-3350-614-7843	dr.andrew.ramirez53@clinic.org
54	Charles	Davis	Pediatrics	+1-3450-221-6321	dr.charles.davis54@clinic.org
55	David	Flores	Oncology	+1-3550-906-6928	dr.david.flores55@clinic.org
56	Jennifer	Ramirez	Rheumatology	+1-3650-308-4986	dr.jennifer.ramirez56@clinic.org
57	Margaret	Nguyen	Pediatrics	+1-3750-736-2288	dr.margaret.nguyen57@clinic.org
58	Betty	Martin	Gastroenterology	+1-3850-547-4630	dr.betty.martin58@clinic.org
59	Nancy	Roberts	Hematology	+1-3950-278-9363	dr.nancy.roberts59@clinic.org
60	Kenneth	Davis	Cardiology	+1-3060-722-4176	dr.kenneth.davis60@clinic.org
61	Deborah	Thompson	Family Medicine	+1-3160-944-3419	dr.deborah.thompson61@clinic.org
62	Jessica	Miller	Hematology	+1-3260-462-4232	dr.jessica.miller62@clinic.org
63	Barbara	Hill	Hematology	+1-3360-978-2234	dr.barbara.hill63@clinic.org
64	Barbara	Roberts	Infectious Disease	+1-3460-705-8601	dr.barbara.roberts64@clinic.org
65	Edward	Torres	Pulmonology	+1-3560-793-8354	dr.edward.torres65@clinic.org
66	Carol	Torres	Infectious Disease	+1-3660-850-6295	dr.carol.torres66@clinic.org
67	Kenneth	Lee	Hematology	+1-3760-650-2118	dr.kenneth.lee67@clinic.org
68	Donald	Lewis	Infectious Disease	+1-3860-510-5500	dr.donald.lewis68@clinic.org
69	Donna	Brown	Family Medicine	+1-3960-719-2215	dr.donna.brown69@clinic.org
70	Karen	Robinson	Oncology	+1-3070-238-1932	dr.karen.robinson70@clinic.org
71	Lisa	Jackson	Internal Medicine	+1-3170-860-2479	dr.lisa.jackson71@clinic.org
72	Michelle	Hill	Cardiology	+1-3270-593-8581	dr.michelle.hill72@clinic.org
73	Donna	Scott	Pulmonology	+1-3370-956-1672	dr.donna.scott73@clinic.org
74	Mark	Torres	Infectious Disease	+1-3470-392-6267	dr.mark.torres74@clinic.org
9	Luis	Jose	Oncology	+1-3900-715-4629	dr.donna.miller9@clinic.org
22	Lisa	Martinez	Infectious Disease	+1-3220-685-2099	dr.lisa.martinez22@clinic.org
75	Joshua	Walker	Cardiology	+1-3570-354-2013	dr.joshua.walker75@clinic.org
76	Mark	Miller	Pulmonology	+1-3670-551-2381	dr.mark.miller76@clinic.org
77	Steven	Adams	Hematology	+1-3770-240-5059	dr.steven.adams77@clinic.org
78	Amanda	Lewis	Oncology	+1-3870-736-9564	dr.amanda.lewis78@clinic.org
79	Michelle	Hernandez	Family Medicine	+1-3970-581-5634	dr.michelle.hernandez79@clinic.org
80	Matthew	Clark	Pulmonology	+1-3080-546-1857	dr.matthew.clark80@clinic.org
81	Kenneth	Adams	Family Medicine	+1-3180-267-6401	dr.kenneth.adams81@clinic.org
82	Michael	Scott	Infectious Disease	+1-3280-595-5655	dr.michael.scott82@clinic.org
83	Thomas	Campbell	Rheumatology	+1-3380-872-3463	dr.thomas.campbell83@clinic.org
84	Nancy	Garcia	Nephrology	+1-3480-879-3317	dr.nancy.garcia84@clinic.org
85	Daniel	Martin	Infectious Disease	+1-3580-915-7421	dr.daniel.martin85@clinic.org
86	William	Hill	Gastroenterology	+1-3680-286-6072	dr.william.hill86@clinic.org
87	Emily	Harris	Infectious Disease	+1-3780-536-3093	dr.emily.harris87@clinic.org
88	Kevin	Hall	Rheumatology	+1-3880-956-9624	dr.kevin.hall88@clinic.org
89	Jennifer	Adams	Infectious Disease	+1-3980-633-9331	dr.jennifer.adams89@clinic.org
90	Lisa	Johnson	Family Medicine	+1-3090-516-3953	dr.lisa.johnson90@clinic.org
91	Susan	Perez	Pulmonology	+1-3190-697-4145	dr.susan.perez91@clinic.org
92	Joseph	Rodriguez	Hematology	+1-3290-279-5846	dr.joseph.rodriguez92@clinic.org
93	Michael	Allen	Pulmonology	+1-3390-752-9626	dr.michael.allen93@clinic.org
94	Robert	Nelson	Family Medicine	+1-3490-984-3147	dr.robert.nelson94@clinic.org
95	Joshua	Harris	Hematology	+1-3590-366-3962	dr.joshua.harris95@clinic.org
96	Brian	Roberts	Nephrology	+1-3690-369-8170	dr.brian.roberts96@clinic.org
97	Robert	Clark	Family Medicine	+1-3790-892-4891	dr.robert.clark97@clinic.org
98	Mark	Flores	Microbiology	+1-3890-970-8355	dr.mark.flores98@clinic.org
99	Joseph	Wright	Endocrinology	+1-3990-516-8684	dr.joseph.wright99@clinic.org
100	Richard	White	Infectious Disease	+1-3001-784-8218	dr.richard.white100@clinic.org
1	Daniel	Royero	Cardiology	+1-3100-412-4538	dr.john.carter1@clinic.org
\.


--
-- TOC entry 3721 (class 0 OID 139274)
-- Dependencies: 239
-- Data for Name: doctors_audit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctors_audit (audit_id, doctor_id, action_doctor, changed_at, changed_by, before_data, after_data) FROM stdin;
1	1	UPDATE	2025-10-16 05:44:29.653494+00	Admin	{"id": 1, "email": "dr.john.carter1@clinic.org", "phone": "+1-3100-412-4538", "last_name": "Carter", "specialty": "Cardiology", "first_name": "John"}	{"id": 1, "email": "dr.john.carter1@clinic.org", "phone": "+1-3100-412-4538", "last_name": "Royero", "specialty": "Cardiology", "first_name": "Daniel"}
2	22	UPDATE	2025-10-16 12:37:56.910004+00	Admin	{"id": 22, "email": "dr.lisa.martinez22@clinic.org", "phone": "+1-3220-685-2099", "last_name": "Martinez", "specialty": "Infectious Disease", "first_name": "Lisa"}	{"id": 22, "email": "dr.lisa.martinez22@clinic.org", "phone": "+1-3220-685-2099", "last_name": "R", "specialty": "Infectious Disease", "first_name": "F"}
3	22	UPDATE	2025-10-16 12:39:41.245164+00	Admin	{"id": 22, "email": "dr.lisa.martinez22@clinic.org", "phone": "+1-3220-685-2099", "last_name": "R", "specialty": "Infectious Disease", "first_name": "F"}	{"id": 22, "email": "dr.lisa.martinez22@clinic.org", "phone": "+1-3220-685-2099", "last_name": "Martinez", "specialty": "Infectious Disease", "first_name": "Lisa"}
4	9	UPDATE	2025-10-16 12:53:48.398863+00	Admin	{"id": 9, "email": "dr.donna.miller9@clinic.org", "phone": "+1-3900-715-4629", "last_name": "Miller", "specialty": "Oncology", "first_name": "Donna"}	{"id": 9, "email": "dr.donna.miller9@clinic.org", "phone": "+1-3900-715-4629", "last_name": "Jose", "specialty": "Oncology", "first_name": "Luis"}
\.


--
-- TOC entry 3700 (class 0 OID 106572)
-- Dependencies: 218
-- Data for Name: insurers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insurers (id, name, phone, email) FROM stdin;
1	HealthSecure 001	+1-3100-654-3725	support1@healthsecure001.com
2	HealthSecure 002	+1-3200-910-5906	support2@healthsecure002.com
3	HealthSecure 003	+1-3300-229-1753	support3@healthsecure003.com
4	HealthSecure 004	+1-3400-532-1919	support4@healthsecure004.com
5	HealthSecure 005	+1-3500-500-6873	support5@healthsecure005.com
6	HealthSecure 006	+1-3600-583-8056	support6@healthsecure006.com
7	HealthSecure 007	+1-3700-349-5000	support7@healthsecure007.com
8	HealthSecure 008	+1-3800-743-7751	support8@healthsecure008.com
9	HealthSecure 009	+1-3900-779-3950	support9@healthsecure009.com
10	HealthSecure 010	+1-3010-374-3868	support10@healthsecure010.com
11	HealthSecure 011	+1-3110-280-7267	support11@healthsecure011.com
12	HealthSecure 012	+1-3210-834-4945	support12@healthsecure012.com
13	HealthSecure 013	+1-3310-709-3344	support13@healthsecure013.com
14	HealthSecure 014	+1-3410-437-8555	support14@healthsecure014.com
15	HealthSecure 015	+1-3510-853-5161	support15@healthsecure015.com
16	HealthSecure 016	+1-3610-670-5183	support16@healthsecure016.com
17	HealthSecure 017	+1-3710-882-1153	support17@healthsecure017.com
18	HealthSecure 018	+1-3810-676-5712	support18@healthsecure018.com
19	HealthSecure 019	+1-3910-893-9955	support19@healthsecure019.com
20	HealthSecure 020	+1-3020-361-2210	support20@healthsecure020.com
21	HealthSecure 021	+1-3120-652-6661	support21@healthsecure021.com
22	HealthSecure 022	+1-3220-801-5901	support22@healthsecure022.com
23	HealthSecure 023	+1-3320-854-7951	support23@healthsecure023.com
24	HealthSecure 024	+1-3420-906-5097	support24@healthsecure024.com
25	HealthSecure 025	+1-3520-667-5949	support25@healthsecure025.com
26	HealthSecure 026	+1-3620-403-7302	support26@healthsecure026.com
27	HealthSecure 027	+1-3720-694-2747	support27@healthsecure027.com
28	HealthSecure 028	+1-3820-442-7248	support28@healthsecure028.com
29	HealthSecure 029	+1-3920-785-6881	support29@healthsecure029.com
30	HealthSecure 030	+1-3030-788-5847	support30@healthsecure030.com
31	HealthSecure 031	+1-3130-916-5837	support31@healthsecure031.com
32	HealthSecure 032	+1-3230-222-7484	support32@healthsecure032.com
33	HealthSecure 033	+1-3330-481-1132	support33@healthsecure033.com
34	HealthSecure 034	+1-3430-779-1803	support34@healthsecure034.com
35	HealthSecure 035	+1-3530-820-9138	support35@healthsecure035.com
36	HealthSecure 036	+1-3630-493-4770	support36@healthsecure036.com
37	HealthSecure 037	+1-3730-821-6772	support37@healthsecure037.com
38	HealthSecure 038	+1-3830-424-4115	support38@healthsecure038.com
39	HealthSecure 039	+1-3930-835-5106	support39@healthsecure039.com
40	HealthSecure 040	+1-3040-894-3240	support40@healthsecure040.com
41	HealthSecure 041	+1-3140-843-2591	support41@healthsecure041.com
42	HealthSecure 042	+1-3240-842-1645	support42@healthsecure042.com
43	HealthSecure 043	+1-3340-516-8222	support43@healthsecure043.com
44	HealthSecure 044	+1-3440-234-6977	support44@healthsecure044.com
45	HealthSecure 045	+1-3540-949-3153	support45@healthsecure045.com
46	HealthSecure 046	+1-3640-292-5835	support46@healthsecure046.com
47	HealthSecure 047	+1-3740-534-7807	support47@healthsecure047.com
48	HealthSecure 048	+1-3840-379-4289	support48@healthsecure048.com
49	HealthSecure 049	+1-3940-335-9837	support49@healthsecure049.com
50	HealthSecure 050	+1-3050-574-9697	support50@healthsecure050.com
51	HealthSecure 051	+1-3150-713-5465	support51@healthsecure051.com
52	HealthSecure 052	+1-3250-368-5210	support52@healthsecure052.com
53	HealthSecure 053	+1-3350-693-5835	support53@healthsecure053.com
54	HealthSecure 054	+1-3450-964-6549	support54@healthsecure054.com
55	HealthSecure 055	+1-3550-317-8673	support55@healthsecure055.com
56	HealthSecure 056	+1-3650-277-3306	support56@healthsecure056.com
57	HealthSecure 057	+1-3750-972-4696	support57@healthsecure057.com
58	HealthSecure 058	+1-3850-892-7511	support58@healthsecure058.com
59	HealthSecure 059	+1-3950-770-6992	support59@healthsecure059.com
60	HealthSecure 060	+1-3060-292-7464	support60@healthsecure060.com
61	HealthSecure 061	+1-3160-214-5332	support61@healthsecure061.com
62	HealthSecure 062	+1-3260-749-3024	support62@healthsecure062.com
63	HealthSecure 063	+1-3360-665-7038	support63@healthsecure063.com
64	HealthSecure 064	+1-3460-888-5295	support64@healthsecure064.com
65	HealthSecure 065	+1-3560-798-7242	support65@healthsecure065.com
66	HealthSecure 066	+1-3660-853-7086	support66@healthsecure066.com
67	HealthSecure 067	+1-3760-310-4830	support67@healthsecure067.com
68	HealthSecure 068	+1-3860-682-1410	support68@healthsecure068.com
69	HealthSecure 069	+1-3960-834-6374	support69@healthsecure069.com
70	HealthSecure 070	+1-3070-824-4626	support70@healthsecure070.com
71	HealthSecure 071	+1-3170-863-2035	support71@healthsecure071.com
72	HealthSecure 072	+1-3270-850-8606	support72@healthsecure072.com
73	HealthSecure 073	+1-3370-917-5951	support73@healthsecure073.com
74	HealthSecure 074	+1-3470-864-7689	support74@healthsecure074.com
75	HealthSecure 075	+1-3570-319-3290	support75@healthsecure075.com
76	HealthSecure 076	+1-3670-246-1609	support76@healthsecure076.com
77	HealthSecure 077	+1-3770-511-9071	support77@healthsecure077.com
78	HealthSecure 078	+1-3870-318-2592	support78@healthsecure078.com
79	HealthSecure 079	+1-3970-440-9807	support79@healthsecure079.com
80	HealthSecure 080	+1-3080-338-7367	support80@healthsecure080.com
81	HealthSecure 081	+1-3180-664-7078	support81@healthsecure081.com
82	HealthSecure 082	+1-3280-886-9850	support82@healthsecure082.com
83	HealthSecure 083	+1-3380-629-3531	support83@healthsecure083.com
84	HealthSecure 084	+1-3480-624-2622	support84@healthsecure084.com
85	HealthSecure 085	+1-3580-701-7686	support85@healthsecure085.com
86	HealthSecure 086	+1-3680-486-1536	support86@healthsecure086.com
87	HealthSecure 087	+1-3780-906-7070	support87@healthsecure087.com
88	HealthSecure 088	+1-3880-422-8264	support88@healthsecure088.com
89	HealthSecure 089	+1-3980-655-4868	support89@healthsecure089.com
90	HealthSecure 090	+1-3090-571-2627	support90@healthsecure090.com
91	HealthSecure 091	+1-3190-902-7018	support91@healthsecure091.com
92	HealthSecure 092	+1-3290-757-6876	support92@healthsecure092.com
93	HealthSecure 093	+1-3390-262-7523	support93@healthsecure093.com
94	HealthSecure 094	+1-3490-482-4109	support94@healthsecure094.com
95	HealthSecure 095	+1-3590-325-8450	support95@healthsecure095.com
96	HealthSecure 096	+1-3690-293-4475	support96@healthsecure096.com
97	HealthSecure 097	+1-3790-857-1349	support97@healthsecure097.com
98	HealthSecure 098	+1-3890-251-6464	support98@healthsecure098.com
99	HealthSecure 099	+1-3990-449-3063	support99@healthsecure099.com
100	HealthSecure 100	+1-3001-778-4362	support100@healthsecure100.com
\.


--
-- TOC entry 3715 (class 0 OID 106660)
-- Dependencies: 233
-- Data for Name: insurers_patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insurers_patients (patient_id, insurer_id, policy_number, status, start_date, end_date) FROM stdin;
1	67	POL20250001	Active	2023-06-11	2025-05-11
2	58	POL20250002	Active	2022-02-14	2023-06-12
3	84	POL20250003	Active	2022-11-25	2024-10-31
4	11	POL20250004	Active	2022-06-21	2022-12-25
5	81	POL20250005	Active	2022-08-04	2023-09-06
6	88	POL20250006	Active	2022-04-17	2023-05-12
7	69	POL20250007	Active	2023-10-25	2024-07-04
8	96	POL20250008	Active	2022-01-25	2023-11-06
9	92	POL20250009	Active	2022-02-08	2022-11-04
10	10	POL20250010	Active	2022-07-02	2023-09-12
11	72	POL20250011	Active	2023-08-12	2024-09-28
12	34	POL20250012	Active	2023-02-02	2024-11-04
13	81	POL20250013	Active	2023-03-20	2024-08-04
14	3	POL20250014	Active	2023-11-21	2024-09-17
15	69	POL20250015	Active	2023-10-19	2024-06-19
16	97	POL20250016	Active	2022-03-16	2023-09-13
17	65	POL20250017	Active	2022-10-24	2024-02-24
18	78	POL20250018	Active	2022-10-16	2024-07-05
19	49	POL20250019	Active	2023-11-08	2024-06-06
20	61	POL20250020	Active	2023-07-01	2024-08-09
21	18	POL20250021	Active	2023-07-13	2024-11-06
22	82	POL20250022	Active	2022-11-02	2024-05-17
23	2	POL20250023	Active	2022-05-07	2022-12-15
24	1	POL20250024	Active	2023-07-05	2024-03-28
25	40	POL20250025	Active	2022-12-19	2024-01-19
26	53	POL20250026	Active	2022-06-14	2023-06-17
27	29	POL20250027	Active	2022-07-18	2023-05-11
28	24	POL20250028	Active	2023-07-17	2025-04-29
29	83	POL20250029	Active	2022-10-25	2023-06-30
30	33	POL20250030	Active	2022-07-22	2024-05-30
31	43	POL20250031	Active	2022-05-12	2023-07-06
32	13	POL20250032	Active	2023-09-27	2024-06-04
33	25	POL20250033	Active	2023-05-13	2025-02-12
34	43	POL20250034	Active	2023-08-22	2024-07-23
35	73	POL20250035	Active	2022-11-20	2024-07-30
36	22	POL20250036	Active	2022-11-17	2024-01-23
37	29	POL20250037	Active	2022-10-11	2024-04-11
38	18	POL20250038	Active	2023-05-07	2025-02-18
39	58	POL20250039	Active	2022-11-09	2024-09-17
40	71	POL20250040	Active	2022-06-29	2023-03-19
41	36	POL20250041	Active	2023-07-06	2024-07-21
42	34	POL20250042	Active	2022-03-19	2022-10-04
43	65	POL20250043	Active	2023-08-19	2025-04-04
44	99	POL20250044	Active	2022-02-07	2023-04-29
45	70	POL20250045	Expired	2023-11-01	2024-09-28
46	47	POL20250046	Active	2022-08-17	2023-12-07
47	18	POL20250047	Active	2023-05-29	2025-04-30
48	12	POL20250048	Active	2023-01-08	2024-12-02
49	2	POL20250049	Active	2023-09-21	2024-09-04
50	97	POL20250050	Active	2023-04-02	2024-03-10
51	23	POL20250051	Active	2023-05-11	2024-11-08
52	6	POL20250052	Active	2023-05-15	2024-07-05
53	9	POL20250053	Active	2023-01-14	2024-03-08
54	6	POL20250054	Active	2023-06-15	2024-12-15
55	50	POL20250055	Active	2023-04-11	2023-11-24
56	6	POL20250056	Active	2022-04-16	2024-03-29
57	82	POL20250057	Active	2022-09-27	2023-09-20
58	49	POL20250058	Active	2023-01-10	2023-09-26
59	67	POL20250059	Active	2023-01-21	2024-03-04
60	67	POL20250060	Expired	2022-12-28	2024-06-13
61	63	POL20250061	Active	2023-09-11	2024-03-15
62	65	POL20250062	Active	2023-03-27	2024-03-10
63	30	POL20250063	Active	2023-06-11	2024-09-20
64	28	POL20250064	Active	2022-07-11	2023-06-17
65	47	POL20250065	Active	2023-11-08	2024-12-27
66	54	POL20250066	Active	2022-04-27	2024-02-29
67	87	POL20250067	Active	2023-05-06	2024-06-04
68	76	POL20250068	Active	2023-10-25	2025-06-16
69	3	POL20250069	Active	2022-02-14	2022-12-21
70	74	POL20250070	Active	2022-05-18	2024-04-21
71	6	POL20250071	Active	2022-02-27	2023-02-12
72	34	POL20250072	Active	2023-06-14	2025-01-29
73	77	POL20250073	Active	2023-11-09	2025-02-21
74	11	POL20250074	Active	2023-04-05	2025-01-26
75	62	POL20250075	Active	2022-08-13	2024-04-04
76	77	POL20250076	Active	2023-08-20	2024-08-20
77	80	POL20250077	Active	2022-06-21	2023-12-03
78	59	POL20250078	Active	2022-08-24	2024-03-13
79	50	POL20250079	Active	2022-04-22	2022-11-04
80	26	POL20250080	Active	2022-06-03	2023-03-08
81	23	POL20250081	Active	2023-09-22	2024-04-28
82	69	POL20250082	Active	2022-04-06	2024-02-08
83	85	POL20250083	Active	2023-09-10	2024-03-09
84	100	POL20250084	Active	2023-06-19	2025-02-18
85	48	POL20250085	Active	2023-06-27	2025-03-07
86	30	POL20250086	Active	2023-01-26	2024-07-17
87	76	POL20250087	Active	2023-03-12	2024-01-23
88	33	POL20250088	Active	2022-08-27	2023-05-19
89	37	POL20250089	Active	2022-09-21	2023-09-29
90	1	POL20250090	Active	2023-08-15	2025-07-30
91	16	POL20250091	Active	2023-01-20	2024-02-14
92	89	POL20250092	Active	2023-02-23	2024-08-26
93	14	POL20250093	Active	2023-03-13	2024-05-25
94	34	POL20250094	Active	2023-08-02	2025-02-06
95	79	POL20250095	Active	2023-11-28	2025-07-06
96	97	POL20250096	Active	2023-02-28	2025-01-02
97	23	POL20250097	Active	2023-07-27	2025-06-01
98	33	POL20250098	Active	2023-08-15	2025-01-28
99	100	POL20250099	Active	2022-05-22	2023-03-19
100	96	POL20250100	Active	2023-04-03	2024-03-13
\.


--
-- TOC entry 3708 (class 0 OID 106600)
-- Dependencies: 226
-- Data for Name: lab_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_orders (id, patient_id, doctor_id, order_date, priority, status, notes) FROM stdin;
1	27	92	2024-08-20 15:05:00	Normal	Pending	Chronic condition monitoring
2	17	66	2024-03-01 14:36:00	Normal	Reported	Chronic condition monitoring
3	87	40	2023-01-23 12:16:00	Normal	Reported	Follow-up
4	75	10	2023-02-16 13:22:00	Normal	Reported	Routine check
5	9	61	2023-02-02 09:26:00	Normal	Pending	General health assessment
6	94	83	2024-03-06 11:57:00	Normal	In_Progress	Chronic condition monitoring
7	49	11	2024-07-06 04:41:00	Normal	Pending	Follow-up
8	69	51	2024-06-25 04:46:00	Normal	Pending	Routine check
9	39	60	2024-07-11 13:34:00	Normal	Pending	Follow-up
10	59	45	2023-06-08 08:12:00	Normal	Pending	General health assessment
11	54	79	2023-01-17 07:13:00	Normal	Pending	Urgent case
12	5	58	2024-09-04 21:45:00	Normal	Pending	General health assessment
13	6	52	2024-03-25 07:34:00	Normal	Pending	Follow-up
14	65	38	2023-08-28 23:36:00	Normal	Reported	Urgent case
15	99	87	2023-11-25 07:19:00	Normal	Reported	Urgent case
16	29	53	2023-11-04 08:03:00	Normal	Reported	General health assessment
17	55	72	2024-05-22 01:22:00	Normal	Reported	Pre-op evaluation
18	90	54	2024-02-23 04:19:00	Normal	Pending	Urgent case
19	61	31	2023-08-19 09:54:00	Normal	In_Progress	Routine check
20	72	53	2024-03-02 17:33:00	Normal	In_Progress	Follow-up
21	33	27	2023-12-05 20:05:00	Normal	In_Progress	Routine check
22	69	93	2023-07-15 01:17:00	Normal	Reported	Urgent case
23	78	6	2023-03-16 06:51:00	Normal	In_Progress	Follow-up
24	43	39	2023-01-16 06:59:00	Normal	Reported	Routine check
25	96	97	2024-05-05 07:44:00	Normal	In_Progress	Follow-up
26	71	42	2023-10-17 12:29:00	Normal	In_Progress	Pre-op evaluation
27	47	66	2024-05-24 14:06:00	Normal	In_Progress	Follow-up
28	48	41	2024-02-28 01:36:00	Normal	Reported	Follow-up
29	3	34	2024-07-20 18:37:00	Normal	In_Progress	Follow-up
30	26	43	2023-08-24 12:36:00	Normal	In_Progress	Urgent case
31	84	88	2023-12-12 08:48:00	Normal	Reported	General health assessment
32	95	63	2024-04-16 05:46:00	Normal	Pending	Follow-up
33	93	70	2024-05-15 05:58:00	Normal	Reported	Routine check
34	10	86	2023-02-19 00:26:00	Normal	Reported	Follow-up
35	9	91	2023-06-04 00:13:00	Normal	In_Progress	Routine check
36	80	82	2024-09-23 15:42:00	Normal	Pending	Routine check
37	69	71	2024-02-26 00:01:00	Normal	Reported	Pre-op evaluation
38	3	65	2024-03-16 05:06:00	Normal	Reported	Follow-up
39	31	25	2024-09-26 16:16:00	Normal	In_Progress	Chronic condition monitoring
40	11	48	2024-02-20 14:36:00	Normal	Reported	Follow-up
41	39	88	2023-03-24 20:54:00	Normal	Pending	Chronic condition monitoring
42	49	49	2024-07-19 15:03:00	Normal	Reported	Follow-up
43	11	64	2024-03-20 20:50:00	Normal	Reported	Routine check
44	68	6	2023-08-24 06:57:00	Normal	In_Progress	Routine check
45	10	88	2023-10-15 17:36:00	Normal	Pending	Pre-op evaluation
46	3	27	2024-08-24 04:48:00	Normal	Pending	Pre-op evaluation
47	21	73	2023-09-04 18:53:00	Normal	Reported	Urgent case
48	43	50	2023-05-24 22:46:00	Normal	Reported	General health assessment
49	45	7	2023-04-11 13:14:00	Normal	In_Progress	Urgent case
50	99	79	2024-09-01 12:49:00	Urgent	Pending	General health assessment
51	35	58	2024-05-17 07:22:00	Normal	In_Progress	Follow-up
52	88	75	2024-01-25 02:49:00	Normal	Pending	General health assessment
53	10	11	2023-10-02 04:24:00	Normal	Reported	Chronic condition monitoring
54	41	47	2023-04-20 02:00:00	Normal	In_Progress	Pre-op evaluation
55	98	35	2023-04-15 04:05:00	Normal	In_Progress	Chronic condition monitoring
56	72	72	2024-06-08 13:06:00	Normal	Pending	Pre-op evaluation
57	71	12	2024-09-03 19:50:00	Normal	In_Progress	Routine check
58	38	53	2024-02-02 02:46:00	Normal	Reported	Urgent case
59	22	88	2024-01-25 05:08:00	Normal	In_Progress	Pre-op evaluation
60	64	19	2023-03-06 05:27:00	Urgent	In_Progress	Pre-op evaluation
61	62	10	2024-01-05 08:15:00	Normal	Reported	Urgent case
62	26	59	2023-04-20 04:19:00	Normal	In_Progress	Pre-op evaluation
63	80	49	2023-12-04 14:21:00	Normal	Reported	Urgent case
64	18	39	2023-11-25 19:44:00	Normal	In_Progress	Pre-op evaluation
65	23	51	2023-11-23 09:47:00	Normal	Reported	Follow-up
66	42	49	2023-10-15 12:23:00	Normal	Reported	Follow-up
67	76	70	2023-07-04 21:49:00	Normal	Reported	Chronic condition monitoring
68	91	27	2024-03-24 09:53:00	Normal	In_Progress	General health assessment
69	64	18	2024-10-10 09:15:00	Normal	Reported	Follow-up
70	92	55	2024-01-22 02:28:00	Urgent	Reported	Chronic condition monitoring
71	69	65	2024-03-04 17:02:00	Normal	Reported	Urgent case
72	77	82	2023-03-29 03:49:00	Normal	Reported	General health assessment
73	46	22	2024-09-19 01:36:00	Normal	In_Progress	Chronic condition monitoring
74	14	2	2023-04-11 08:14:00	Normal	In_Progress	Pre-op evaluation
75	51	60	2024-08-25 22:32:00	Normal	In_Progress	Routine check
76	62	14	2023-10-30 13:58:00	Normal	Pending	General health assessment
77	19	45	2023-11-16 10:29:00	Normal	Reported	Chronic condition monitoring
78	45	61	2023-04-10 14:46:00	Normal	In_Progress	Routine check
79	39	6	2023-04-28 00:54:00	Normal	Reported	Routine check
80	87	22	2023-09-07 16:11:00	Normal	In_Progress	Urgent case
81	55	60	2023-08-26 12:40:00	Normal	Pending	General health assessment
82	85	56	2024-02-10 00:47:00	Normal	In_Progress	Urgent case
83	55	50	2023-01-05 22:13:00	Normal	In_Progress	General health assessment
84	9	74	2023-04-15 17:11:00	Normal	In_Progress	Follow-up
85	59	15	2023-09-26 21:55:00	Normal	Reported	General health assessment
86	41	77	2024-02-02 19:25:00	Normal	In_Progress	Pre-op evaluation
87	59	80	2023-06-26 21:45:00	Normal	Reported	Urgent case
88	11	87	2023-05-18 10:07:00	Normal	In_Progress	Routine check
89	24	48	2023-05-25 16:24:00	Normal	Reported	Follow-up
90	74	50	2024-03-09 05:31:00	Normal	Reported	Follow-up
91	63	37	2023-05-24 05:20:00	Normal	Reported	Routine check
92	46	2	2024-05-11 04:12:00	Normal	Reported	Urgent case
93	84	64	2024-02-23 21:31:00	Normal	Reported	Chronic condition monitoring
94	63	22	2023-03-26 18:01:00	Normal	In_Progress	Routine check
95	36	29	2024-07-04 09:10:00	Normal	Reported	General health assessment
96	99	99	2024-05-22 17:32:00	Normal	Reported	Routine check
97	35	100	2024-07-10 11:34:00	Normal	Reported	Chronic condition monitoring
98	70	28	2024-03-11 03:47:00	Normal	In_Progress	Routine check
99	58	34	2023-12-23 02:28:00	Normal	Pending	Follow-up
100	95	76	2023-12-26 22:39:00	Urgent	Pending	Urgent case
\.


--
-- TOC entry 3725 (class 0 OID 139334)
-- Dependencies: 243
-- Data for Name: lab_orders_audit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_orders_audit (audit_id, order_id, action_order, changed_at, changed_by, before_data, after_data) FROM stdin;
\.


--
-- TOC entry 3717 (class 0 OID 106691)
-- Dependencies: 235
-- Data for Name: lab_orders_tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_orders_tests (lab_order_id, test_id) FROM stdin;
14	34
80	20
11	84
50	40
30	32
95	37
57	81
17	17
68	22
4	5
85	46
42	61
60	70
35	71
57	18
90	70
23	76
77	59
81	96
82	73
56	68
82	82
69	40
45	62
70	30
12	57
40	47
53	34
20	39
2	1
67	98
18	45
37	61
69	2
89	63
97	62
39	2
99	56
38	77
30	1
71	48
25	53
72	56
51	32
21	92
95	83
50	49
29	34
11	55
81	31
79	89
88	35
37	84
96	69
35	53
25	9
24	18
38	15
82	59
80	58
35	90
80	63
25	42
3	20
7	69
3	24
14	37
35	17
92	57
94	2
30	12
20	2
64	28
44	54
40	64
48	60
90	5
43	11
97	19
8	35
100	51
10	70
61	24
25	33
49	2
16	99
92	32
50	99
57	32
95	5
26	59
95	99
13	67
86	27
61	50
88	40
42	21
81	94
6	96
71	67
\.


--
-- TOC entry 3704 (class 0 OID 106584)
-- Dependencies: 222
-- Data for Name: panels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.panels (id, name, description, estimated_time, cost) FROM stdin;
1	Panel 001 - Hormonal	Panel 001 focused on risk assessment.	75	160.81
2	Panel 002 - Hormonal	Panel 002 focused on diagnostic evaluation.	45	244.35
3	Panel 003 - Wellness	Panel 003 focused on risk assessment.	30	199.53
4	Panel 004 - Allergy	Panel 004 focused on chronic disease monitoring.	30	219.19
5	Panel 005 - Metabolic	Panel 005 focused on routine screening.	60	43.49
6	Panel 006 - Wellness	Panel 006 focused on risk assessment.	75	273.49
7	Panel 007 - Wellness	Panel 007 focused on preoperative evaluation.	30	285.00
8	Panel 008 - Wellness	Panel 008 focused on preoperative evaluation.	60	280.53
9	Panel 009 - Hormonal	Panel 009 focused on routine screening.	75	160.56
10	Panel 010 - Wellness	Panel 010 focused on preoperative evaluation.	30	124.98
11	Panel 011 - General Chemistry	Panel 011 focused on risk assessment.	30	254.97
12	Panel 012 - Cardiac	Panel 012 focused on risk assessment.	45	58.53
13	Panel 013 - Allergy	Panel 013 focused on preoperative evaluation.	120	252.71
14	Panel 014 - Cardiac	Panel 014 focused on preoperative evaluation.	75	192.30
15	Panel 015 - General Chemistry	Panel 015 focused on routine screening.	60	80.38
16	Panel 016 - Wellness	Panel 016 focused on chronic disease monitoring.	120	190.49
17	Panel 017 - Hormonal	Panel 017 focused on routine screening.	60	86.54
18	Panel 018 - General Chemistry	Panel 018 focused on routine screening.	45	137.55
19	Panel 019 - Metabolic	Panel 019 focused on preoperative evaluation.	30	51.04
20	Panel 020 - Hormonal	Panel 020 focused on chronic disease monitoring.	90	24.60
21	Panel 021 - Metabolic	Panel 021 focused on chronic disease monitoring.	45	221.19
22	Panel 022 - Allergy	Panel 022 focused on preoperative evaluation.	30	192.15
23	Panel 023 - Wellness	Panel 023 focused on chronic disease monitoring.	75	72.45
24	Panel 024 - Cardiac	Panel 024 focused on routine screening.	90	292.90
25	Panel 025 - General Chemistry	Panel 025 focused on chronic disease monitoring.	90	162.05
26	Panel 026 - Metabolic	Panel 026 focused on chronic disease monitoring.	30	129.33
27	Panel 027 - Hormonal	Panel 027 focused on routine screening.	120	128.33
28	Panel 028 - Allergy	Panel 028 focused on risk assessment.	120	24.55
29	Panel 029 - General Chemistry	Panel 029 focused on risk assessment.	45	225.22
30	Panel 030 - Cardiac	Panel 030 focused on routine screening.	90	225.85
31	Panel 031 - Allergy	Panel 031 focused on diagnostic evaluation.	30	118.64
32	Panel 032 - Allergy	Panel 032 focused on diagnostic evaluation.	120	150.09
33	Panel 033 - Cardiac	Panel 033 focused on preoperative evaluation.	120	71.04
34	Panel 034 - Wellness	Panel 034 focused on routine screening.	120	237.33
35	Panel 035 - Hormonal	Panel 035 focused on routine screening.	60	76.45
36	Panel 036 - Wellness	Panel 036 focused on routine screening.	60	281.34
37	Panel 037 - Metabolic	Panel 037 focused on preoperative evaluation.	90	152.55
38	Panel 038 - General Chemistry	Panel 038 focused on diagnostic evaluation.	60	119.95
39	Panel 039 - General Chemistry	Panel 039 focused on risk assessment.	60	54.85
40	Panel 040 - Allergy	Panel 040 focused on preoperative evaluation.	75	228.13
41	Panel 041 - Hormonal	Panel 041 focused on risk assessment.	45	158.94
42	Panel 042 - Hormonal	Panel 042 focused on risk assessment.	90	94.68
43	Panel 043 - General Chemistry	Panel 043 focused on preoperative evaluation.	30	140.57
44	Panel 044 - Wellness	Panel 044 focused on chronic disease monitoring.	60	109.94
45	Panel 045 - General Chemistry	Panel 045 focused on risk assessment.	120	102.78
46	Panel 046 - Hormonal	Panel 046 focused on chronic disease monitoring.	120	139.31
47	Panel 047 - Cardiac	Panel 047 focused on preoperative evaluation.	60	145.20
48	Panel 048 - Cardiac	Panel 048 focused on risk assessment.	90	299.48
49	Panel 049 - Allergy	Panel 049 focused on routine screening.	30	207.93
50	Panel 050 - Hormonal	Panel 050 focused on risk assessment.	90	244.31
51	Panel 051 - Cardiac	Panel 051 focused on diagnostic evaluation.	30	59.98
52	Panel 052 - Metabolic	Panel 052 focused on preoperative evaluation.	30	55.34
53	Panel 053 - Wellness	Panel 053 focused on risk assessment.	60	127.20
54	Panel 054 - Metabolic	Panel 054 focused on routine screening.	90	62.96
55	Panel 055 - Hormonal	Panel 055 focused on risk assessment.	60	144.30
56	Panel 056 - General Chemistry	Panel 056 focused on chronic disease monitoring.	45	168.25
57	Panel 057 - Hormonal	Panel 057 focused on risk assessment.	120	98.03
58	Panel 058 - General Chemistry	Panel 058 focused on routine screening.	120	72.09
59	Panel 059 - Metabolic	Panel 059 focused on preoperative evaluation.	90	52.97
60	Panel 060 - Allergy	Panel 060 focused on preoperative evaluation.	45	298.98
61	Panel 061 - Allergy	Panel 061 focused on preoperative evaluation.	45	54.34
62	Panel 062 - General Chemistry	Panel 062 focused on preoperative evaluation.	45	271.63
63	Panel 063 - Hormonal	Panel 063 focused on routine screening.	120	290.92
64	Panel 064 - Allergy	Panel 064 focused on risk assessment.	120	38.18
65	Panel 065 - Metabolic	Panel 065 focused on risk assessment.	60	258.38
66	Panel 066 - Cardiac	Panel 066 focused on diagnostic evaluation.	60	162.45
67	Panel 067 - General Chemistry	Panel 067 focused on diagnostic evaluation.	45	86.29
68	Panel 068 - Hormonal	Panel 068 focused on routine screening.	60	175.13
69	Panel 069 - Allergy	Panel 069 focused on preoperative evaluation.	90	56.34
70	Panel 070 - General Chemistry	Panel 070 focused on routine screening.	60	131.48
71	Panel 071 - Cardiac	Panel 071 focused on preoperative evaluation.	90	135.02
72	Panel 072 - Hormonal	Panel 072 focused on chronic disease monitoring.	30	55.09
73	Panel 073 - Allergy	Panel 073 focused on routine screening.	75	150.43
74	Panel 074 - Metabolic	Panel 074 focused on risk assessment.	45	265.83
75	Panel 075 - Metabolic	Panel 075 focused on chronic disease monitoring.	45	234.98
76	Panel 076 - Wellness	Panel 076 focused on preoperative evaluation.	90	275.00
77	Panel 077 - General Chemistry	Panel 077 focused on routine screening.	90	62.84
78	Panel 078 - Wellness	Panel 078 focused on diagnostic evaluation.	60	281.73
79	Panel 079 - Wellness	Panel 079 focused on risk assessment.	90	270.58
80	Panel 080 - General Chemistry	Panel 080 focused on risk assessment.	45	197.82
81	Panel 081 - Metabolic	Panel 081 focused on risk assessment.	45	195.01
82	Panel 082 - Metabolic	Panel 082 focused on chronic disease monitoring.	30	160.72
83	Panel 083 - Wellness	Panel 083 focused on chronic disease monitoring.	90	63.17
84	Panel 084 - Cardiac	Panel 084 focused on chronic disease monitoring.	120	272.56
85	Panel 085 - Allergy	Panel 085 focused on chronic disease monitoring.	30	251.07
86	Panel 086 - General Chemistry	Panel 086 focused on routine screening.	30	285.59
87	Panel 087 - Metabolic	Panel 087 focused on risk assessment.	120	79.03
88	Panel 088 - Metabolic	Panel 088 focused on preoperative evaluation.	90	198.92
89	Panel 089 - Hormonal	Panel 089 focused on chronic disease monitoring.	60	199.73
90	Panel 090 - Allergy	Panel 090 focused on preoperative evaluation.	45	245.31
91	Panel 091 - Cardiac	Panel 091 focused on preoperative evaluation.	60	146.99
92	Panel 092 - Cardiac	Panel 092 focused on routine screening.	45	143.09
93	Panel 093 - Hormonal	Panel 093 focused on preoperative evaluation.	45	115.25
94	Panel 094 - Wellness	Panel 094 focused on risk assessment.	120	109.41
95	Panel 095 - Allergy	Panel 095 focused on preoperative evaluation.	45	232.99
96	Panel 096 - Metabolic	Panel 096 focused on chronic disease monitoring.	30	109.35
97	Panel 097 - Hormonal	Panel 097 focused on routine screening.	60	145.89
98	Panel 098 - Wellness	Panel 098 focused on routine screening.	30	101.26
99	Panel 099 - Hormonal	Panel 099 focused on chronic disease monitoring.	75	89.52
100	Panel 100 - Wellness	Panel 100 focused on risk assessment.	90	221.92
\.


--
-- TOC entry 3716 (class 0 OID 106676)
-- Dependencies: 234
-- Data for Name: panels_tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.panels_tests (panel_id, test_id) FROM stdin;
13	28
66	52
44	71
79	90
88	91
7	21
50	82
1	12
19	61
77	56
12	9
34	29
48	11
78	5
93	50
52	79
84	67
37	92
77	8
100	23
82	64
57	2
26	85
67	37
25	5
77	66
67	90
30	79
22	87
5	47
31	84
1	21
12	36
100	52
46	86
51	52
76	26
67	2
95	91
9	12
71	37
93	72
75	45
45	36
29	78
25	59
52	74
1	34
23	53
65	14
72	10
65	38
44	15
66	33
69	74
33	89
57	49
73	62
99	32
97	44
100	59
88	59
76	4
62	15
34	9
49	82
29	87
90	30
41	53
46	67
69	2
90	34
32	37
12	52
87	96
44	10
71	23
61	41
46	28
74	35
24	96
88	25
64	95
26	31
95	31
34	27
30	26
32	80
46	20
100	14
16	11
87	85
64	79
1	98
70	6
62	48
80	41
64	74
36	63
24	98
\.


--
-- TOC entry 3710 (class 0 OID 106621)
-- Dependencies: 228
-- Data for Name: parameters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parameters (id, test_id, name, unit, reference_values, data_type) FROM stdin;
1	1	Parameter 001	mmol/L	0.5-1.5	Numeric
2	2	Parameter 002	mg/dL	Positive	Text
3	3	Parameter 003	pg/mL	150-450	Numeric
4	4	Parameter 004	%	150-450	Text
5	5	Parameter 005	cells/uL	150-450	Numeric
6	6	Parameter 006	mmol/L	>50	Numeric
7	7	Parameter 007	µIU/mL	3.5-5.0	Numeric
8	8	Parameter 008	ng/mL	3.5-5.0	Text
9	9	Parameter 009	ng/mL	>50	Text
10	10	Parameter 010	mmol/L	Positive	Text
11	11	Parameter 011	U/L	>50	Text
12	12	Parameter 012	g/dL	12-16	Text
13	13	Parameter 013	pg/mL	150-450	Text
14	14	Parameter 014	IU/L	Normal	Text
15	15	Parameter 015	cells/uL	70-110	Boolean
16	16	Parameter 016	g/dL	Normal	Text
17	17	Parameter 017	g/dL	Negative	Text
18	18	Parameter 018	ng/mL	>50	Numeric
19	19	Parameter 019	IU/L	150-450	Text
20	20	Parameter 020	µIU/mL	<200	Numeric
21	21	Parameter 021	cells/uL	Normal	Text
22	22	Parameter 022	mg/dL	70-110	Numeric
23	23	Parameter 023	IU/L	70-110	Numeric
24	24	Parameter 024	mmol/L	Normal	Text
25	25	Parameter 025	mg/dL	>50	Numeric
26	26	Parameter 026	mmol/L	150-450	Numeric
27	27	Parameter 027	µIU/mL	12-16	Text
28	28	Parameter 028	µIU/mL	12-16	Text
29	29	Parameter 029	mmol/L	70-110	Text
30	30	Parameter 030	µIU/mL	0.5-1.5	Text
31	31	Parameter 031	g/dL	12-16	Numeric
32	32	Parameter 032	ng/mL	Normal	Numeric
33	33	Parameter 033	mmol/L	Positive	Numeric
34	34	Parameter 034	pg/mL	Normal	Numeric
35	35	Parameter 035	mg/dL	<200	Numeric
36	36	Parameter 036	U/L	3.5-5.0	Text
37	37	Parameter 037	g/dL	0.5-1.5	Text
38	38	Parameter 038	g/dL	12-16	Numeric
39	39	Parameter 039	%	<200	Text
40	40	Parameter 040	mmol/L	>50	Numeric
41	41	Parameter 041	mmol/L	12-16	Numeric
42	42	Parameter 042	cells/uL	3.5-5.0	Text
43	43	Parameter 043	%	0.5-1.5	Numeric
44	44	Parameter 044	U/L	Positive	Text
45	45	Parameter 045	ng/mL	12-16	Numeric
46	46	Parameter 046	mmol/L	12-16	Text
47	47	Parameter 047	%	>50	Text
48	48	Parameter 048	mmol/L	0.5-1.5	Text
49	49	Parameter 049	g/dL	0.5-1.5	Text
50	50	Parameter 050	mg/dL	150-450	Numeric
51	51	Parameter 051	pg/mL	Positive	Numeric
52	52	Parameter 052	U/L	150-450	Numeric
53	53	Parameter 053	ng/mL	Normal	Text
54	54	Parameter 054	g/dL	0.5-1.5	Text
55	55	Parameter 055	cells/uL	12-16	Numeric
56	56	Parameter 056	%	<200	Numeric
57	57	Parameter 057	U/L	Positive	Text
58	58	Parameter 058	%	Negative	Numeric
59	59	Parameter 059	IU/L	12-16	Numeric
60	60	Parameter 060	cells/uL	12-16	Numeric
61	61	Parameter 061	µIU/mL	0.5-1.5	Numeric
62	62	Parameter 062	mg/dL	>50	Text
63	63	Parameter 063	pg/mL	>50	Text
64	64	Parameter 064	U/L	12-16	Numeric
65	65	Parameter 065	µIU/mL	12-16	Text
66	66	Parameter 066	g/dL	Negative	Numeric
67	67	Parameter 067	mmol/L	Negative	Text
68	68	Parameter 068	U/L	Positive	Numeric
69	69	Parameter 069	µIU/mL	>50	Numeric
70	70	Parameter 070	mg/dL	0.5-1.5	Numeric
71	71	Parameter 071	U/L	12-16	Text
72	72	Parameter 072	cells/uL	Positive	Numeric
73	73	Parameter 073	µIU/mL	3.5-5.0	Numeric
74	74	Parameter 074	mg/dL	3.5-5.0	Numeric
75	75	Parameter 075	mmol/L	Normal	Text
76	76	Parameter 076	pg/mL	Negative	Text
77	77	Parameter 077	mmol/L	<200	Numeric
78	78	Parameter 078	µIU/mL	12-16	Numeric
79	79	Parameter 079	%	>50	Text
80	80	Parameter 080	pg/mL	12-16	Text
81	81	Parameter 081	cells/uL	12-16	Text
82	82	Parameter 082	IU/L	Negative	Text
83	83	Parameter 083	mg/dL	Normal	Numeric
84	84	Parameter 084	%	3.5-5.0	Text
85	85	Parameter 085	g/dL	Positive	Numeric
86	86	Parameter 086	ng/mL	Negative	Numeric
87	87	Parameter 087	mg/dL	70-110	Numeric
88	88	Parameter 088	mg/dL	Normal	Text
89	89	Parameter 089	U/L	3.5-5.0	Numeric
90	90	Parameter 090	mg/dL	Negative	Boolean
91	91	Parameter 091	U/L	0.5-1.5	Text
92	92	Parameter 092	ng/mL	>50	Text
93	93	Parameter 093	µIU/mL	12-16	Text
94	94	Parameter 094	g/dL	Negative	Numeric
95	95	Parameter 095	mmol/L	0.5-1.5	Numeric
96	96	Parameter 096	U/L	12-16	Text
97	97	Parameter 097	µIU/mL	150-450	Text
98	98	Parameter 098	g/dL	Negative	Text
99	99	Parameter 099	mg/dL	<200	Numeric
100	100	Parameter 100	µIU/mL	Positive	Text
\.


--
-- TOC entry 3698 (class 0 OID 106562)
-- Dependencies: 216
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patients (id, first_name, last_name, document_number, birth_date, sex, address, phone, email) FROM stdin;
1	Kenneth	Davis	ID20250001	1947-03-31	F	4022 Cedar Ln., Greenville, TX 98696	+1-3100-958-9935	kenneth.davis1@example.com
2	Jennifer	Nguyen	ID20250002	1982-11-08	M	498 Maple Ave., Riverton, NY 76237	+1-3200-816-1434	jennifer.nguyen2@example.com
3	Emily	Gonzalez	ID20250003	2003-04-22	F	3621 Sunset Blvd., Madison, PA 10851	+1-3300-977-3615	emily.gonzalez3@example.com
4	Brian	Ramirez	ID20250004	1975-07-12	F	2557 Cedar Ln., Hillsborough, TX 22156	+1-3400-589-2584	brian.ramirez4@example.com
5	Daniel	Thompson	ID20250005	1999-03-01	F	721 Sunset Blvd., Clinton, TX 59615	+1-3500-280-5803	daniel.thompson5@example.com
6	Kenneth	Flores	ID20250006	1977-06-12	M	1149 Oak St., Riverton, PA 20458	+1-3600-438-2654	kenneth.flores6@example.com
7	Matthew	Moore	ID20250007	1985-09-05	F	2674 Birch Ave., Hillsborough, NY 97841	+1-3700-473-2169	matthew.moore7@example.com
8	Joshua	Green	ID20250008	1960-05-09	M	2687 Sunset Blvd., Georgetown, PA 93886	+1-3800-904-4598	joshua.green8@example.com
11	Thomas	Mitchell	ID20250011	1997-06-12	F	9570 Willow Dr., Hillsborough, NY 28131	+1-3110-721-9085	thomas.mitchell11@example.com
12	Jennifer	Carter	ID20250012	1949-03-24	M	2514 Pine Rd., Georgetown, MI 18326	+1-3210-594-7252	jennifer.carter12@example.com
13	Joshua	Robinson	ID20250013	1992-06-21	F	9074 Oak St., Fairview, NC 44973	+1-3310-987-6573	joshua.robinson13@example.com
14	Linda	Jackson	ID20250014	1984-01-03	M	7443 Oak St., Lakeside, NC 33416	+1-3410-719-2743	linda.jackson14@example.com
15	Kenneth	Martin	ID20250015	2002-04-29	M	2514 Birch Ave., Greenville, NC 79514	+1-3510-200-6310	kenneth.martin15@example.com
16	Ashley	Johnson	ID20250016	1955-01-14	F	5048 Cedar Ln., Springfield, NY 84364	+1-3610-280-2403	ashley.johnson16@example.com
17	George	Young	ID20250017	1951-03-18	Other	2070 Pine Rd., Franklin, NC 31643	+1-3710-471-9645	george.young17@example.com
18	Joshua	Ramirez	ID20250018	1964-01-02	M	5117 Willow Dr., Hillsborough, GA 77839	+1-3810-662-2982	joshua.ramirez18@example.com
19	Jessica	Anderson	ID20250019	1950-09-30	F	354 Riverside Ave., Clinton, NY 87128	+1-3910-425-1117	jessica.anderson19@example.com
20	John	Rivera	ID20250020	2001-08-14	M	3760 Maple Ave., Springfield, IL 19287	+1-3020-726-4899	john.rivera20@example.com
21	Sarah	Nelson	ID20250021	1988-07-20	M	8844 Pine Rd., Madison, MI 71953	+1-3120-448-8749	sarah.nelson21@example.com
22	Anthony	Gonzalez	ID20250022	1953-06-18	M	7072 Birch Ave., Georgetown, OH 71213	+1-3220-946-1887	anthony.gonzalez22@example.com
23	Carol	Adams	ID20250023	2002-12-22	M	1003 Willow Dr., Hillsborough, TX 42591	+1-3320-396-4116	carol.adams23@example.com
24	Paul	Lewis	ID20250024	1957-07-30	F	3016 Elm St., Franklin, NY 19880	+1-3420-653-2604	paul.lewis24@example.com
25	Patricia	Adams	ID20250025	1993-07-01	M	1538 Cedar Ln., Greenville, OH 73653	+1-3520-692-4502	patricia.adams25@example.com
26	Betty	Brown	ID20250026	1959-10-09	F	45 Willow Dr., Lakeside, GA 47388	+1-3620-633-8973	betty.brown26@example.com
27	Elizabeth	Gonzalez	ID20250027	1971-08-15	M	968 Riverside Ave., Clinton, CA 51104	+1-3720-258-1821	elizabeth.gonzalez27@example.com
28	Donna	Walker	ID20250028	1990-02-11	M	941 Highland Rd., Fairview, FL 18981	+1-3820-809-2113	donna.walker28@example.com
29	Carol	Thomas	ID20250029	1981-03-23	M	9343 Cedar Ln., Madison, MI 15209	+1-3920-834-2343	carol.thomas29@example.com
30	Anthony	Nelson	ID20250030	1997-05-13	F	4282 Cedar Ln., Hillsborough, NY 44814	+1-3030-605-3144	anthony.nelson30@example.com
31	Kevin	Adams	ID20250031	1971-12-01	F	5190 Maple Ave., Springfield, GA 91416	+1-3130-776-2638	kevin.adams31@example.com
32	John	Wright	ID20250032	1964-02-15	F	2180 Birch Ave., Fairview, NY 58434	+1-3230-491-3584	john.wright32@example.com
33	Mark	Wright	ID20250033	1972-02-21	M	9096 Elm St., Fairview, FL 44664	+1-3330-318-2753	mark.wright33@example.com
34	Melissa	Scott	ID20250034	1958-12-12	F	4626 Riverside Ave., Riverton, IL 36685	+1-3430-903-5325	melissa.scott34@example.com
35	Steven	Young	ID20250035	1967-07-13	M	1522 Willow Dr., Lakeside, CA 10464	+1-3530-541-3143	steven.young35@example.com
36	Kenneth	Taylor	ID20250036	1959-07-01	F	9048 Willow Dr., Clinton, CA 24663	+1-3630-277-3442	kenneth.taylor36@example.com
37	Paul	Williams	ID20250037	1978-02-15	M	7051 Pine Rd., Springfield, PA 57795	+1-3730-240-6862	paul.williams37@example.com
38	Susan	Baker	ID20250038	1967-05-22	M	5804 Highland Rd., Georgetown, MI 30257	+1-3830-442-3662	susan.baker38@example.com
39	Barbara	Clark	ID20250039	1947-03-24	M	5452 Willow Dr., Riverton, PA 30866	+1-3930-918-2771	barbara.clark39@example.com
40	Matthew	Williams	ID20250040	1987-03-25	M	3279 Sunset Blvd., Hillsborough, PA 39831	+1-3040-428-1387	matthew.williams40@example.com
41	Kevin	Gonzalez	ID20250041	1980-09-30	F	4574 Maple Ave., Lakeside, IL 94080	+1-3140-721-7548	kevin.gonzalez41@example.com
42	Carol	Wright	ID20250042	1974-09-17	M	1899 Elm St., Greenville, MI 44795	+1-3240-239-2776	carol.wright42@example.com
43	Joshua	Ramirez	ID20250043	1976-01-06	F	7159 Riverside Ave., Clinton, TX 60488	+1-3340-790-4114	joshua.ramirez43@example.com
44	Thomas	Williams	ID20250044	1984-02-14	M	8528 Highland Rd., Riverton, IL 66531	+1-3440-271-6409	thomas.williams44@example.com
45	Michelle	Lee	ID20250045	2004-07-07	M	4930 Highland Rd., Lakeside, OH 52753	+1-3540-612-5844	michelle.lee45@example.com
46	Emily	Rodriguez	ID20250046	1962-03-19	F	6221 Pine Rd., Madison, MI 49446	+1-3640-615-9977	emily.rodriguez46@example.com
47	James	Martin	ID20250047	1970-09-28	M	7053 Riverside Ave., Madison, IL 70946	+1-3740-652-8244	james.martin47@example.com
48	Carol	Wilson	ID20250048	1990-11-11	F	2790 Maple Ave., Lakeside, NC 97012	+1-3840-848-6491	carol.wilson48@example.com
49	Jennifer	Carter	ID20250049	1966-01-27	F	3690 Cedar Ln., Greenville, CA 16057	+1-3940-450-8784	jennifer.carter49@example.com
50	Michelle	Roberts	ID20250050	1951-07-15	F	6800 Riverside Ave., Riverton, OH 74799	+1-3050-609-4997	michelle.roberts50@example.com
51	Elizabeth	Adams	ID20250051	2006-09-10	M	1756 Willow Dr., Riverton, FL 77889	+1-3150-675-1822	elizabeth.adams51@example.com
52	Emily	Thomas	ID20250052	1955-11-21	F	2194 Sunset Blvd., Clinton, NC 88047	+1-3250-524-8251	emily.thomas52@example.com
53	Michelle	Campbell	ID20250053	1990-04-15	F	8986 Sunset Blvd., Greenville, GA 68991	+1-3350-465-5050	michelle.campbell53@example.com
9	Pedro	Peña	ID20250009	1950-01-07	M	535 Birch Ave., Georgetown, PA 18675	+1-3900-416-6155	carol.lee9@example.com
54	Kenneth	Moore	ID20250054	1991-10-08	F	3929 Elm St., Franklin, TX 47450	+1-3450-440-5451	kenneth.moore54@example.com
55	Nancy	Lee	ID20250055	1993-06-17	M	2277 Pine Rd., Riverton, OH 30028	+1-3550-923-4505	nancy.lee55@example.com
56	John	Clark	ID20250056	1981-07-27	F	8900 Sunset Blvd., Georgetown, CA 37110	+1-3650-630-7381	john.clark56@example.com
57	Deborah	Nguyen	ID20250057	1946-10-03	F	7824 Oak St., Hillsborough, PA 61116	+1-3750-629-9818	deborah.nguyen57@example.com
58	Melissa	Mitchell	ID20250058	1993-12-30	M	8009 Cedar Ln., Lakeside, OH 73654	+1-3850-229-7371	melissa.mitchell58@example.com
59	Nancy	Nelson	ID20250059	2005-12-06	F	2714 Sunset Blvd., Greenville, MI 80008	+1-3950-227-7455	nancy.nelson59@example.com
60	Donna	Torres	ID20250060	2004-06-25	M	1385 Willow Dr., Greenville, GA 33819	+1-3060-251-5262	donna.torres60@example.com
61	Matthew	Lee	ID20250061	1963-12-28	F	5365 Birch Ave., Georgetown, PA 65255	+1-3160-458-2341	matthew.lee61@example.com
62	Donald	Johnson	ID20250062	1993-05-24	M	5743 Cedar Ln., Fairview, CA 14067	+1-3260-453-4266	donald.johnson62@example.com
63	Mary	Flores	ID20250063	1958-09-03	M	2078 Sunset Blvd., Fairview, MI 38569	+1-3360-676-5198	mary.flores63@example.com
64	Deborah	White	ID20250064	1960-01-21	M	2693 Elm St., Fairview, MI 13365	+1-3460-519-7149	deborah.white64@example.com
65	Betty	Rivera	ID20250065	1962-10-17	M	9710 Cedar Ln., Fairview, PA 99687	+1-3560-814-2983	betty.rivera65@example.com
66	Andrew	Williams	ID20250066	1976-02-25	F	6081 Maple Ave., Clinton, IL 11658	+1-3660-630-9031	andrew.williams66@example.com
67	Michael	Ramirez	ID20250067	1977-06-30	F	2516 Willow Dr., Greenville, NC 95256	+1-3760-476-9817	michael.ramirez67@example.com
68	Deborah	Walker	ID20250068	1986-09-15	F	9717 Elm St., Hillsborough, NY 21359	+1-3860-485-8385	deborah.walker68@example.com
69	Jessica	Carter	ID20250069	1986-09-10	F	5521 Oak St., Franklin, IL 33834	+1-3960-699-4475	jessica.carter69@example.com
70	Daniel	Taylor	ID20250070	1975-07-15	F	9777 Elm St., Clinton, CA 77715	+1-3070-395-2402	daniel.taylor70@example.com
71	Jessica	Campbell	ID20250071	1981-06-18	F	9106 Cedar Ln., Franklin, GA 68743	+1-3170-217-2524	jessica.campbell71@example.com
72	Charles	Anderson	ID20250072	1981-04-13	M	5026 Riverside Ave., Hillsborough, GA 82544	+1-3270-743-6632	charles.anderson72@example.com
73	Margaret	Mitchell	ID20250073	1994-05-19	F	5774 Sunset Blvd., Lakeside, PA 42951	+1-3370-436-2976	margaret.mitchell73@example.com
74	George	Gonzalez	ID20250074	1973-04-23	M	8789 Pine Rd., Riverton, NY 73464	+1-3470-483-9595	george.gonzalez74@example.com
75	Joshua	Jackson	ID20250075	1954-01-08	M	4863 Cedar Ln., Hillsborough, FL 49618	+1-3570-214-9751	joshua.jackson75@example.com
76	William	Moore	ID20250076	1949-01-31	M	9076 Elm St., Greenville, GA 23446	+1-3670-212-5658	william.moore76@example.com
77	Donald	Walker	ID20250077	1984-07-08	F	3030 Oak St., Lakeside, GA 24953	+1-3770-266-7565	donald.walker77@example.com
78	Ashley	Jones	ID20250078	1996-10-07	M	2495 Pine Rd., Madison, PA 21164	+1-3870-454-2940	ashley.jones78@example.com
79	Emily	Carter	ID20250079	1982-05-04	M	8571 Willow Dr., Franklin, GA 48974	+1-3970-802-8025	emily.carter79@example.com
80	Karen	Torres	ID20250080	2000-09-18	M	9998 Maple Ave., Riverton, NY 44687	+1-3080-876-2330	karen.torres80@example.com
81	David	Thomas	ID20250081	1960-08-05	M	2574 Oak St., Georgetown, GA 87832	+1-3180-681-5771	david.thomas81@example.com
82	Robert	Anderson	ID20250082	1970-11-06	F	7448 Maple Ave., Riverton, PA 91927	+1-3280-803-4241	robert.anderson82@example.com
83	Margaret	Davis	ID20250083	1993-11-09	M	2451 Elm St., Greenville, TX 17816	+1-3380-369-6039	margaret.davis83@example.com
84	Joshua	Mitchell	ID20250084	1996-01-25	F	7205 Maple Ave., Franklin, PA 62757	+1-3480-478-9199	joshua.mitchell84@example.com
85	Paul	Young	ID20250085	1984-04-10	M	9808 Oak St., Georgetown, IL 89129	+1-3580-456-1423	paul.young85@example.com
86	Jennifer	Anderson	ID20250086	2005-06-30	M	4425 Riverside Ave., Springfield, FL 71669	+1-3680-731-8245	jennifer.anderson86@example.com
87	Sarah	Lopez	ID20250087	1997-07-07	F	8066 Maple Ave., Franklin, IL 63523	+1-3780-541-6260	sarah.lopez87@example.com
88	Kevin	Miller	ID20250088	1959-06-06	F	6754 Sunset Blvd., Lakeside, OH 82102	+1-3880-237-8451	kevin.miller88@example.com
89	Jennifer	Lee	ID20250089	1967-08-24	F	1909 Willow Dr., Clinton, CA 96200	+1-3980-755-8569	jennifer.lee89@example.com
90	Anthony	Brown	ID20250090	1961-10-30	F	8177 Sunset Blvd., Springfield, NY 45003	+1-3090-762-3146	anthony.brown90@example.com
91	Charles	Lewis	ID20250091	1988-06-27	M	482 Riverside Ave., Riverton, FL 50730	+1-3190-764-1224	charles.lewis91@example.com
92	Emily	Clark	ID20250092	1953-05-13	M	1868 Sunset Blvd., Fairview, FL 75323	+1-3290-933-5781	emily.clark92@example.com
93	Steven	Rivera	ID20250093	1969-07-13	F	7915 Sunset Blvd., Riverton, GA 82255	+1-3390-348-7284	steven.rivera93@example.com
94	Richard	Hill	ID20250094	1990-08-07	M	1153 Elm St., Georgetown, IL 76550	+1-3490-473-1042	richard.hill94@example.com
95	Charles	Campbell	ID20250095	1971-10-15	F	2444 Sunset Blvd., Clinton, GA 55236	+1-3590-540-9903	charles.campbell95@example.com
96	Matthew	Robinson	ID20250096	1973-11-14	M	3922 Riverside Ave., Georgetown, NY 63841	+1-3690-244-6213	matthew.robinson96@example.com
97	Melissa	Walker	ID20250097	1979-03-16	F	2502 Sunset Blvd., Springfield, FL 75836	+1-3790-804-6439	melissa.walker97@example.com
98	Michael	Lewis	ID20250098	1953-12-12	F	261 Pine Rd., Georgetown, FL 19807	+1-3890-680-5342	michael.lewis98@example.com
99	Nancy	Flores	ID20250099	1980-08-29	M	5393 Highland Rd., Georgetown, IL 92155	+1-3990-935-8994	nancy.flores99@example.com
100	Paul	Williams	ID20250100	2000-05-24	M	3856 Elm St., Riverton, TX 66881	+1-3001-300-2646	paul.williams100@example.com
10	Fernanda	Colemann	ID20250010	1989-10-15	F	7527 Pine Rd., Lakeside, FL 42325	+1-3010-962-9830	susan.adams10@example.com
\.


--
-- TOC entry 3723 (class 0 OID 139304)
-- Dependencies: 241
-- Data for Name: patients_audit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patients_audit (audit_id, patient_id, action_patient, changed_at, changed_by, before_data, after_data) FROM stdin;
1	10	UPDATE	2025-10-16 12:55:02.330256+00	Admin	{"id": 10, "sex": "F", "email": "susan.adams10@example.com", "phone": "+1-3010-962-9830", "address": "7527 Pine Rd., Lakeside, FL 42325", "last_name": "Adams", "birth_date": "1989-10-15", "first_name": "Susan", "document_number": "ID20250010"}	{"id": 10, "sex": "F", "email": "susan.adams10@example.com", "phone": "+1-3010-962-9830", "address": "7527 Pine Rd., Lakeside, FL 42325", "last_name": "Coleman", "birth_date": "1989-10-15", "first_name": "Fernanda", "document_number": "ID20250010"}
2	10	UPDATE	2025-10-16 12:55:42.524503+00	Admin	{"id": 10, "sex": "F", "email": "susan.adams10@example.com", "phone": "+1-3010-962-9830", "address": "7527 Pine Rd., Lakeside, FL 42325", "last_name": "Coleman", "birth_date": "1989-10-15", "first_name": "Fernanda", "document_number": "ID20250010"}	{"id": 10, "sex": "F", "email": "susan.adams10@example.com", "phone": "+1-3010-962-9830", "address": "7527 Pine Rd., Lakeside, FL 42325", "last_name": "Colemann", "birth_date": "1989-10-15", "first_name": "Fernanda", "document_number": "ID20250010"}
3	9	UPDATE	2025-10-16 13:22:19.811273+00	Admin	{"id": 9, "sex": "M", "email": "carol.lee9@example.com", "phone": "+1-3900-416-6155", "address": "535 Birch Ave., Georgetown, PA 18675", "last_name": "Lee", "birth_date": "1950-01-07", "first_name": "Carol", "document_number": "ID20250009"}	{"id": 9, "sex": "M", "email": "carol.lee9@example.com", "phone": "+1-3900-416-6155", "address": "535 Birch Ave., Georgetown, PA 18675", "last_name": "Peña", "birth_date": "1950-01-07", "first_name": "Pedro", "document_number": "ID20250009"}
\.


--
-- TOC entry 3714 (class 0 OID 106648)
-- Dependencies: 232
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, lab_order_id, amount, payment_date, payment_method, status) FROM stdin;
2	2	457.53	2023-08-28 19:51:00	Cash	Pending
3	3	141.15	2023-11-04 22:45:00	Transfer	Completed
4	4	449.83	2023-11-26 14:16:00	Card	Completed
5	5	165.03	2024-02-22 19:25:00	Cash	Pending
6	6	265.53	2023-12-09 17:41:00	Transfer	Completed
7	7	348.52	2024-02-02 02:21:00	Transfer	Completed
8	8	433.52	2023-10-12 20:45:00	Transfer	Pending
9	9	91.97	2023-10-02 01:51:00	Insurance	Completed
10	10	346.76	2023-06-14 20:31:00	Transfer	Completed
11	11	455.32	2023-12-25 12:47:00	Cash	Pending
12	12	184.72	2023-09-22 21:34:00	Insurance	Completed
13	13	263.51	2023-08-27 21:56:00	Card	Completed
14	14	66.85	2023-08-05 23:16:00	Card	Completed
15	15	334.13	2023-09-22 11:14:00	Transfer	Completed
16	16	398.28	2023-11-17 11:16:00	Transfer	Completed
17	17	428.58	2024-01-27 01:55:00	Cash	Completed
18	18	446.92	2024-02-12 03:55:00	Insurance	Completed
19	19	218.29	2023-08-17 04:12:00	Transfer	Completed
20	20	493.85	2024-01-21 04:20:00	Card	Pending
21	21	254.04	2023-08-30 10:40:00	Cash	Pending
22	22	236.99	2023-09-16 05:36:00	Card	Completed
23	23	396.90	2023-07-16 04:39:00	Insurance	Completed
24	24	213.63	2024-01-31 12:00:00	Cash	Pending
25	25	370.72	2023-06-08 10:48:00	Card	Pending
26	26	344.84	2023-10-06 07:44:00	Transfer	Completed
27	27	81.89	2023-12-14 16:37:00	Transfer	Pending
28	28	51.34	2023-06-24 09:18:00	Insurance	Completed
29	29	228.16	2023-08-08 10:57:00	Insurance	Completed
30	30	380.06	2023-08-24 12:01:00	Card	Pending
31	31	369.04	2023-08-07 06:46:00	Cash	Pending
32	32	79.12	2023-06-20 12:56:00	Transfer	Pending
33	33	305.08	2023-06-25 21:06:00	Cash	Pending
34	34	351.08	2023-12-31 14:24:00	Cash	Completed
35	35	247.71	2023-08-18 06:44:00	Cash	Completed
36	36	222.02	2023-07-22 21:33:00	Transfer	Pending
37	37	221.04	2023-07-24 16:46:00	Cash	Completed
38	38	74.73	2023-07-25 15:12:00	Card	Completed
39	39	419.12	2023-09-12 11:45:00	Insurance	Completed
40	40	96.98	2024-03-07 15:58:00	Card	Rejected
41	41	467.90	2023-11-17 07:00:00	Cash	Pending
42	42	455.30	2024-03-20 21:31:00	Card	Pending
43	43	394.17	2023-07-09 23:46:00	Cash	Completed
44	44	329.28	2024-01-20 09:16:00	Insurance	Pending
45	45	67.91	2023-08-29 01:54:00	Transfer	Completed
46	46	404.77	2023-11-08 13:47:00	Cash	Pending
47	47	428.60	2023-06-24 00:54:00	Card	Pending
48	48	177.76	2024-01-11 19:17:00	Cash	Completed
49	49	411.18	2023-09-02 03:25:00	Insurance	Completed
50	50	150.48	2023-12-15 22:54:00	Insurance	Completed
51	51	331.45	2023-08-25 03:08:00	Cash	Pending
52	52	69.78	2024-02-03 18:43:00	Insurance	Pending
53	53	313.44	2023-12-01 19:01:00	Card	Completed
54	54	461.79	2023-07-28 13:28:00	Cash	Pending
55	55	145.57	2023-11-08 00:45:00	Card	Completed
56	56	269.17	2023-07-19 13:42:00	Card	Completed
57	57	185.96	2023-12-15 04:53:00	Cash	Pending
58	58	328.83	2023-08-20 16:54:00	Insurance	Completed
59	59	437.32	2023-07-09 15:20:00	Card	Completed
60	60	485.67	2023-06-26 16:14:00	Insurance	Completed
61	61	412.21	2023-07-11 14:28:00	Insurance	Pending
62	62	431.16	2024-01-15 10:07:00	Insurance	Pending
63	63	69.27	2023-12-29 01:35:00	Cash	Pending
64	64	400.06	2023-11-03 16:35:00	Card	Completed
65	65	476.17	2023-12-04 01:52:00	Card	Completed
66	66	179.35	2024-01-29 22:42:00	Transfer	Completed
67	67	74.73	2023-09-22 00:21:00	Transfer	Completed
68	68	282.89	2023-12-09 22:06:00	Cash	Pending
69	69	256.36	2023-12-27 03:16:00	Card	Pending
70	70	77.96	2023-12-19 06:29:00	Card	Completed
71	71	71.73	2023-12-30 01:59:00	Cash	Completed
72	72	239.55	2024-02-14 04:31:00	Cash	Pending
73	73	285.55	2024-01-08 18:30:00	Card	Pending
74	74	370.64	2023-08-05 03:24:00	Transfer	Completed
75	75	220.96	2023-10-06 08:25:00	Transfer	Completed
76	76	237.37	2023-08-08 04:26:00	Transfer	Completed
77	77	361.70	2024-03-10 20:13:00	Card	Pending
78	78	319.60	2023-10-27 21:22:00	Card	Pending
79	79	261.87	2023-11-13 22:07:00	Transfer	Completed
80	80	299.75	2023-12-31 21:47:00	Transfer	Completed
81	81	407.99	2024-02-23 03:01:00	Insurance	Pending
82	82	45.47	2023-06-29 06:17:00	Card	Completed
83	83	348.03	2023-08-14 01:44:00	Transfer	Pending
84	84	381.73	2023-06-17 11:52:00	Insurance	Pending
85	85	315.73	2024-03-14 07:47:00	Insurance	Pending
86	86	265.24	2023-10-26 22:42:00	Cash	Completed
87	87	206.03	2023-11-08 17:03:00	Cash	Completed
88	88	117.48	2024-01-13 07:58:00	Transfer	Pending
89	89	392.55	2023-09-08 09:28:00	Card	Pending
90	90	109.75	2023-08-28 23:32:00	Cash	Completed
91	91	39.50	2023-10-21 17:16:00	Card	Pending
92	92	300.31	2023-10-09 00:21:00	Insurance	Pending
93	93	39.17	2023-11-13 19:03:00	Transfer	Completed
94	94	399.16	2024-03-08 11:04:00	Transfer	Pending
95	95	479.35	2024-02-22 02:50:00	Card	Completed
96	96	280.68	2023-12-24 02:22:00	Card	Pending
97	97	338.40	2023-11-17 11:18:00	Card	Completed
98	98	498.38	2023-06-05 03:42:00	Transfer	Completed
99	99	135.37	2023-10-03 01:43:00	Transfer	Completed
100	100	459.65	2023-07-29 12:16:00	Transfer	Pending
1	1	2.00	2023-12-27 16:01:00	Cash	Completed
\.


--
-- TOC entry 3731 (class 0 OID 139424)
-- Dependencies: 249
-- Data for Name: payments_audit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments_audit (audit_id, payment_id, action_payment, changed_at, changed_by, before_data, after_data) FROM stdin;
1	1	UPDATE	2025-10-16 11:59:20.131679+00	Admin	{"id": 1, "amount": 119.23, "status": "Completed", "lab_order_id": 1, "payment_date": "2023-12-27T16:01:00", "payment_method": "Cash"}	{"id": 1, "amount": 2.00, "status": "Completed", "lab_order_id": 1, "payment_date": "2023-12-27T16:01:00", "payment_method": "Cash"}
\.


--
-- TOC entry 3719 (class 0 OID 106707)
-- Dependencies: 237
-- Data for Name: results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.results (id, sample_id, parameter_id, value, result_date, doctor_id) FROM stdin;
1	1	16	Positive	2023-06-27 21:13:00	33
2	2	15	98.7	2023-10-20 18:07:00	31
3	3	51	Abnormal	2024-01-30 22:38:00	32
4	4	20	Negative	2023-07-17 21:39:00	48
5	5	44	Abnormal	2023-08-18 22:34:00	98
6	6	14	Normal	2023-11-25 14:46:00	17
7	7	25	103.7	2023-10-07 01:31:00	3
8	8	91	Negative	2023-09-06 18:11:00	57
9	9	70	Normal	2024-03-10 05:04:00	45
10	10	68	Normal	2023-12-05 14:00:00	20
11	11	100	7.64	2023-12-04 19:15:00	82
12	12	42	Negative	2023-09-06 16:43:00	93
13	13	64	Positive	2023-12-27 20:20:00	99
14	14	15	60.0	2023-08-31 01:12:00	13
15	15	14	Abnormal	2023-12-16 21:31:00	63
16	16	68	Positive	2023-09-22 19:45:00	80
17	17	10	Negative	2023-07-11 14:51:00	2
18	18	82	Negative	2023-12-06 22:03:00	8
19	19	79	Positive	2023-07-10 06:33:00	35
20	20	13	129.7	2023-09-07 16:42:00	13
21	21	32	Abnormal	2024-03-12 13:47:00	73
22	22	14	Negative	2024-01-05 03:10:00	99
23	23	24	100.6	2024-02-29 19:28:00	71
24	24	46	Positive	2023-12-29 20:27:00	41
25	25	93	134.5	2023-12-10 17:59:00	42
26	26	96	Negative	2023-06-01 23:02:00	33
27	27	37	Positive	2023-06-04 09:14:00	77
28	28	28	Abnormal	2023-10-20 17:32:00	41
29	29	72	13.9	2024-01-22 11:09:00	74
30	30	18	137.3	2023-10-10 09:05:00	34
31	31	74	8.58	2023-11-14 15:11:00	52
32	32	63	10.57	2023-11-01 01:46:00	89
33	33	74	Positive	2023-11-26 13:26:00	49
34	34	16	Normal	2023-06-06 20:49:00	99
35	35	81	Positive	2024-03-03 18:09:00	49
36	36	42	Abnormal	2023-12-19 14:48:00	65
37	37	77	Positive	2023-12-19 04:08:00	74
38	38	44	Normal	2023-12-22 08:05:00	11
39	39	52	154.7	2024-02-02 17:12:00	65
40	40	63	Normal	2024-02-24 07:15:00	51
41	41	10	Normal	2023-07-16 03:42:00	35
42	42	53	Positive	2023-06-13 09:10:00	55
43	43	45	Normal	2023-08-14 14:02:00	79
44	44	30	Abnormal	2023-07-14 03:47:00	26
45	45	7	Positive	2023-06-08 10:44:00	32
46	46	15	53.4	2024-03-02 06:13:00	40
47	47	70	Normal	2023-08-12 22:44:00	67
48	48	86	Normal	2023-06-23 08:10:00	3
49	49	8	Positive	2023-06-28 14:41:00	37
50	50	2	Abnormal	2023-12-02 03:01:00	9
51	51	38	Normal	2023-07-21 10:31:00	84
52	52	77	Negative	2024-03-14 22:01:00	69
53	53	6	Negative	2023-12-19 23:10:00	32
54	54	3	Positive	2023-09-29 16:17:00	45
55	55	8	3.94	2024-03-11 08:14:00	81
56	56	20	13.47	2023-12-13 16:43:00	44
57	57	79	Normal	2023-08-18 13:19:00	81
58	58	78	Abnormal	2023-08-10 18:34:00	43
59	59	88	Abnormal	2024-02-24 04:27:00	26
60	60	99	134.7	2023-11-10 02:35:00	19
61	61	69	97.6	2023-06-16 10:56:00	93
62	62	53	Abnormal	2023-10-19 04:49:00	53
63	63	25	Normal	2023-10-15 19:36:00	14
64	64	79	8.99	2023-12-01 02:44:00	30
65	65	100	Negative	2023-12-09 05:54:00	62
66	66	50	74.6	2023-06-17 13:48:00	63
67	67	2	Abnormal	2023-09-12 06:04:00	35
68	68	23	Positive	2024-01-21 07:27:00	57
69	69	52	Negative	2023-11-08 12:39:00	100
70	70	96	Abnormal	2023-06-20 16:06:00	74
71	71	58	56.4	2024-02-21 17:25:00	59
72	72	95	Abnormal	2023-06-26 06:18:00	6
73	73	57	Positive	2024-01-23 05:27:00	51
74	74	38	153.5	2024-01-24 20:28:00	79
75	75	12	Normal	2024-03-06 04:25:00	93
76	76	53	Normal	2023-09-12 14:05:00	42
77	77	33	186.1	2023-08-03 02:07:00	42
78	78	91	Abnormal	2023-12-14 23:50:00	58
79	79	66	Negative	2023-06-23 05:58:00	79
80	80	43	179.4	2023-08-14 05:49:00	73
81	81	92	Negative	2023-10-26 20:11:00	7
82	82	16	Positive	2023-06-07 14:31:00	17
83	83	64	Negative	2023-09-30 06:37:00	70
84	84	85	Normal	2023-06-04 07:56:00	61
85	85	71	133.6	2023-06-26 05:09:00	36
86	86	8	5.3	2024-03-22 19:19:00	84
87	87	43	112.5	2023-08-22 21:18:00	12
88	88	79	Normal	2023-08-30 14:47:00	85
89	89	75	Positive	2023-11-13 11:57:00	47
90	90	49	11.4	2023-10-28 15:08:00	9
91	91	16	Negative	2024-02-24 06:44:00	89
92	92	27	Abnormal	2024-02-26 02:30:00	79
93	93	93	Abnormal	2023-10-26 13:38:00	89
94	94	41	Positive	2023-08-06 19:36:00	34
95	95	64	124.7	2023-09-28 22:18:00	67
96	96	25	1.86	2023-09-15 19:26:00	1
97	97	53	Abnormal	2023-09-17 00:40:00	6
98	98	26	Positive	2023-11-01 16:35:00	89
99	99	42	Positive	2023-12-20 23:36:00	99
100	100	79	Positive	2024-02-01 15:51:00	4
\.


--
-- TOC entry 3729 (class 0 OID 139394)
-- Dependencies: 247
-- Data for Name: results_audit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.results_audit (audit_id, result_id, action_result, changed_at, changed_by, before_data, after_data) FROM stdin;
\.


--
-- TOC entry 3712 (class 0 OID 106633)
-- Dependencies: 230
-- Data for Name: samples; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.samples (id, lab_order_id, type, collected_at, status, notes) FROM stdin;
1	1	Pleural Fluid	2023-10-03 14:23:00	Discarded	Low volume collected
2	2	Synovial Fluid	2023-10-04 04:00:00	Discarded	Sample adequate
3	3	Urine	2024-03-04 11:40:00	Collected	Possible contamination
4	4	Blood	2023-12-10 23:46:00	Used	Sample adequate
5	5	Urine	2024-02-27 07:26:00	Discarded	Sample adequate
6	6	Plasma	2023-10-22 02:02:00	In_Progress	Re-collection needed
7	7	CSF	2023-12-08 14:47:00	Collected	Re-collection needed
8	8	Serum	2024-02-14 04:40:00	Discarded	Sample adequate
9	9	Pleural Fluid	2024-03-17 01:27:00	In_Progress	Low volume collected
10	10	Stool	2023-10-12 10:59:00	Discarded	Initial collection successful
11	11	Saliva	2023-11-10 14:17:00	In_Progress	Sample adequate
12	12	Urine	2023-08-09 18:06:00	In_Progress	Sample adequate
13	13	Plasma	2024-01-17 14:20:00	Discarded	Sample adequate
14	14	Synovial Fluid	2023-12-01 06:28:00	Used	Transported under cold chain
15	15	Stool	2023-08-01 02:10:00	Used	Initial collection successful
16	16	Pleural Fluid	2023-06-21 06:53:00	Used	Low volume collected
17	17	Serum	2023-10-06 11:25:00	Collected	Initial collection successful
18	18	Stool	2023-10-12 05:01:00	Discarded	Transported under cold chain
19	19	Synovial Fluid	2024-03-08 07:06:00	Discarded	Sample adequate
20	20	Plasma	2023-08-02 00:03:00	In_Progress	Low volume collected
21	21	Urine	2023-12-23 11:43:00	Collected	Re-collection needed
22	22	Pleural Fluid	2023-10-11 02:01:00	Collected	Low volume collected
23	23	Sputum	2023-08-05 02:57:00	Used	Sample adequate
24	24	Blood	2024-01-23 01:10:00	Discarded	Initial collection successful
25	25	CSF	2024-02-10 00:24:00	Discarded	Low volume collected
26	26	Saliva	2023-09-18 05:17:00	Used	Transported under cold chain
27	27	Plasma	2023-06-18 19:39:00	In_Progress	Initial collection successful
28	28	Stool	2024-02-11 13:56:00	Discarded	Sample adequate
29	29	Serum	2023-10-22 12:08:00	Discarded	Low volume collected
30	30	Synovial Fluid	2023-10-06 20:51:00	Collected	Transported under cold chain
31	31	Saliva	2024-02-01 17:50:00	Discarded	Possible contamination
32	32	Pleural Fluid	2024-02-13 10:24:00	Used	Low volume collected
33	33	Blood	2023-11-11 19:14:00	Collected	Possible contamination
34	34	Blood	2024-01-28 16:22:00	In_Progress	Low volume collected
35	35	Serum	2023-10-05 21:15:00	Used	Re-collection needed
36	36	Blood	2023-09-21 18:54:00	Discarded	Possible contamination
37	37	Plasma	2023-08-30 07:37:00	Used	Initial collection successful
38	38	Saliva	2023-06-15 22:44:00	Used	Re-collection needed
39	39	Pleural Fluid	2023-08-12 18:12:00	Discarded	Re-collection needed
40	40	Stool	2023-08-29 15:02:00	Collected	Sample adequate
41	41	Urine	2023-09-21 00:33:00	Discarded	Sample adequate
42	42	Saliva	2023-09-12 04:21:00	In_Progress	Possible contamination
43	43	Blood	2023-06-12 04:37:00	In_Progress	Sample adequate
44	44	Synovial Fluid	2023-12-04 02:23:00	Discarded	Re-collection needed
45	45	Serum	2023-11-20 09:20:00	In_Progress	Low volume collected
46	46	CSF	2024-02-05 20:20:00	In_Progress	Initial collection successful
47	47	Synovial Fluid	2023-11-30 07:42:00	In_Progress	Transported under cold chain
48	48	Stool	2023-10-29 04:11:00	Collected	Initial collection successful
49	49	Pleural Fluid	2023-12-18 18:02:00	In_Progress	Re-collection needed
50	50	Saliva	2023-09-22 20:36:00	Collected	Transported under cold chain
51	51	Plasma	2023-11-17 23:04:00	In_Progress	Possible contamination
52	52	Saliva	2023-08-25 20:56:00	Collected	Initial collection successful
53	53	Saliva	2024-01-15 00:16:00	In_Progress	Low volume collected
54	54	Serum	2023-11-27 08:50:00	Collected	Initial collection successful
55	55	Blood	2023-06-25 12:28:00	Discarded	Low volume collected
56	56	CSF	2024-02-08 12:22:00	Discarded	Sample adequate
57	57	Sputum	2024-03-22 20:48:00	In_Progress	Low volume collected
58	58	Sputum	2023-07-08 01:18:00	Collected	Possible contamination
59	59	Stool	2023-07-24 02:21:00	In_Progress	Transported under cold chain
60	60	Plasma	2023-07-09 17:57:00	Collected	Possible contamination
61	61	Pleural Fluid	2024-02-03 22:01:00	Discarded	Initial collection successful
62	62	Plasma	2024-01-09 05:03:00	Collected	Possible contamination
63	63	Urine	2023-09-06 13:44:00	Used	Initial collection successful
64	64	Stool	2023-10-31 07:06:00	Collected	Transported under cold chain
65	65	Pleural Fluid	2024-03-08 15:09:00	Collected	Possible contamination
66	66	Blood	2024-01-05 02:18:00	Discarded	Low volume collected
67	67	Serum	2023-06-14 06:10:00	Used	Sample adequate
68	68	Sputum	2023-07-30 09:50:00	Discarded	Transported under cold chain
69	69	Sputum	2023-10-14 02:41:00	Discarded	Low volume collected
70	70	Saliva	2023-12-13 11:11:00	Discarded	Sample adequate
71	71	Stool	2024-01-12 14:16:00	In_Progress	Possible contamination
72	72	Pleural Fluid	2023-07-02 04:48:00	Collected	Sample adequate
73	73	Saliva	2024-03-04 13:48:00	In_Progress	Re-collection needed
74	74	Blood	2023-12-16 16:26:00	Discarded	Re-collection needed
75	75	Urine	2024-01-30 09:05:00	Discarded	Initial collection successful
76	76	Blood	2024-02-13 18:57:00	In_Progress	Sample adequate
77	77	Sputum	2023-08-28 05:13:00	In_Progress	Low volume collected
78	78	Blood	2024-01-03 02:43:00	Discarded	Low volume collected
79	79	Plasma	2023-10-11 10:58:00	Collected	Sample adequate
80	80	CSF	2024-03-11 12:35:00	Used	Possible contamination
81	81	Synovial Fluid	2024-01-21 00:50:00	Discarded	Sample adequate
82	82	CSF	2023-08-16 04:36:00	Collected	Sample adequate
83	83	Pleural Fluid	2023-07-22 09:55:00	Used	Transported under cold chain
84	84	Stool	2023-12-14 20:31:00	Discarded	Sample adequate
85	85	Plasma	2023-10-20 12:09:00	Discarded	Sample adequate
86	86	CSF	2023-11-17 22:15:00	Collected	Initial collection successful
87	87	Sputum	2023-10-16 11:01:00	Used	Possible contamination
88	88	Stool	2023-10-22 15:54:00	Collected	Low volume collected
89	89	Plasma	2023-11-01 23:28:00	Used	Possible contamination
90	90	CSF	2023-07-16 06:28:00	In_Progress	Transported under cold chain
91	91	Sputum	2024-02-20 11:52:00	Collected	Re-collection needed
92	92	Plasma	2023-07-04 09:45:00	Discarded	Low volume collected
93	93	Synovial Fluid	2024-03-18 00:11:00	In_Progress	Low volume collected
94	94	Blood	2023-10-06 01:29:00	Collected	Possible contamination
95	95	Urine	2023-10-19 11:52:00	Discarded	Re-collection needed
96	96	CSF	2023-08-03 21:01:00	In_Progress	Possible contamination
97	97	Sputum	2024-01-15 05:55:00	Discarded	Re-collection needed
98	98	Synovial Fluid	2023-11-27 11:10:00	Used	Initial collection successful
99	99	Serum	2023-10-24 00:24:00	Collected	Low volume collected
100	100	Pleural Fluid	2023-09-18 07:41:00	In_Progress	Initial collection successful
\.


--
-- TOC entry 3727 (class 0 OID 139364)
-- Dependencies: 245
-- Data for Name: samples_audit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.samples_audit (audit_id, sample_id, action_sample, changed_at, changed_by, before_data, after_data) FROM stdin;
\.


--
-- TOC entry 3706 (class 0 OID 106592)
-- Dependencies: 224
-- Data for Name: tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tests (id, name, description, sample_type, estimated_time, cost) FROM stdin;
1	Complete Blood Count	Complete Blood Count for clinical assessment and monitoring.	Urine	20	77.25
2	Comprehensive Metabolic Panel	Comprehensive Metabolic Panel for clinical assessment and monitoring.	Synovial Fluid	45	77.32
3	Basic Metabolic Panel	Basic Metabolic Panel for clinical assessment and monitoring.	Stool	45	8.36
4	Lipid Panel	Lipid Panel for clinical assessment and monitoring.	CSF	60	71.30
5	Thyroid Stimulating Hormone	Thyroid Stimulating Hormone for clinical assessment and monitoring.	Urine	20	89.58
6	Free T4	Free T4 for clinical assessment and monitoring.	Blood	15	45.80
7	Hemoglobin A1c	Hemoglobin A1c for clinical assessment and monitoring.	Pleural Fluid	45	46.43
8	C-Reactive Protein	C-Reactive Protein for clinical assessment and monitoring.	Blood	15	67.48
9	Erythrocyte Sedimentation Rate	Erythrocyte Sedimentation Rate for clinical assessment and monitoring.	Stool	30	115.76
10	Prothrombin Time	Prothrombin Time for clinical assessment and monitoring.	Saliva	15	63.08
11	INR	INR for clinical assessment and monitoring.	Pleural Fluid	60	33.23
12	Activated Partial Thromboplastin Time	Activated Partial Thromboplastin Time for clinical assessment and monitoring.	Synovial Fluid	30	15.66
13	Liver Function Tests	Liver Function Tests for clinical assessment and monitoring.	Synovial Fluid	45	115.84
14	Renal Function Panel	Renal Function Panel for clinical assessment and monitoring.	Stool	60	103.66
15	Urinalysis	Urinalysis for clinical assessment and monitoring.	Serum	20	146.39
16	Vitamin D 25-OH	Vitamin D 25-OH for clinical assessment and monitoring.	CSF	30	120.26
17	Ferritin	Ferritin for clinical assessment and monitoring.	Saliva	60	141.15
18	Serum Iron	Serum Iron for clinical assessment and monitoring.	Plasma	20	92.36
19	TIBC	TIBC for clinical assessment and monitoring.	CSF	60	10.84
20	Transferrin	Transferrin for clinical assessment and monitoring.	Blood	20	108.47
21	B12	B12 for clinical assessment and monitoring.	Sputum	60	71.26
22	Folate	Folate for clinical assessment and monitoring.	Pleural Fluid	60	25.27
23	Uric Acid	Uric Acid for clinical assessment and monitoring.	Pleural Fluid	30	28.56
24	Amylase	Amylase for clinical assessment and monitoring.	Pleural Fluid	30	91.09
25	Lipase	Lipase for clinical assessment and monitoring.	Synovial Fluid	60	82.19
26	Troponin I	Troponin I for clinical assessment and monitoring.	Pleural Fluid	30	73.86
27	Troponin T	Troponin T for clinical assessment and monitoring.	Blood	30	53.03
28	BNP	BNP for clinical assessment and monitoring.	Serum	45	89.64
29	Pro-BNP	Pro-BNP for clinical assessment and monitoring.	Blood	60	73.82
30	D-Dimer	D-Dimer for clinical assessment and monitoring.	Pleural Fluid	60	37.99
31	Calcium	Calcium for clinical assessment and monitoring.	Blood	60	74.67
32	Phosphorus	Phosphorus for clinical assessment and monitoring.	Synovial Fluid	60	117.32
33	Magnesium	Magnesium for clinical assessment and monitoring.	CSF	20	124.14
34	Potassium	Potassium for clinical assessment and monitoring.	Urine	15	88.02
35	Sodium	Sodium for clinical assessment and monitoring.	Serum	20	7.75
36	Chloride	Chloride for clinical assessment and monitoring.	Saliva	45	26.96
37	Bicarbonate	Bicarbonate for clinical assessment and monitoring.	Urine	45	77.76
38	ALT	ALT for clinical assessment and monitoring.	Pleural Fluid	45	131.56
39	AST	AST for clinical assessment and monitoring.	Blood	20	80.21
40	Alkaline Phosphatase	Alkaline Phosphatase for clinical assessment and monitoring.	Synovial Fluid	30	149.73
41	GGT	GGT for clinical assessment and monitoring.	Sputum	60	59.64
42	Bilirubin Total	Bilirubin Total for clinical assessment and monitoring.	Plasma	45	137.26
43	Bilirubin Direct	Bilirubin Direct for clinical assessment and monitoring.	Saliva	60	56.37
44	Albumin	Albumin for clinical assessment and monitoring.	Stool	60	75.21
45	Total Protein	Total Protein for clinical assessment and monitoring.	Urine	30	85.92
46	LDH	LDH for clinical assessment and monitoring.	Urine	30	116.82
47	CK Total	CK Total for clinical assessment and monitoring.	Urine	45	50.97
48	CK-MB	CK-MB for clinical assessment and monitoring.	Saliva	60	140.39
49	Creatinine	Creatinine for clinical assessment and monitoring.	Stool	30	22.67
50	BUN	BUN for clinical assessment and monitoring.	Synovial Fluid	45	134.89
51	Glucose	Glucose for clinical assessment and monitoring.	CSF	30	143.42
52	Insulin	Insulin for clinical assessment and monitoring.	Plasma	30	11.10
53	HOMA-IR	HOMA-IR for clinical assessment and monitoring.	Serum	30	138.98
54	HCG Quantitative	HCG Quantitative for clinical assessment and monitoring.	Stool	45	36.03
55	PSA Total	PSA Total for clinical assessment and monitoring.	Synovial Fluid	30	140.29
56	PSA Free	PSA Free for clinical assessment and monitoring.	Stool	20	20.84
57	CEA	CEA for clinical assessment and monitoring.	Pleural Fluid	20	40.16
58	CA-125	CA-125 for clinical assessment and monitoring.	Synovial Fluid	20	97.50
59	CA 19-9	CA 19-9 for clinical assessment and monitoring.	Blood	15	64.93
60	AFP	AFP for clinical assessment and monitoring.	Sputum	15	103.77
61	ANA	ANA for clinical assessment and monitoring.	Plasma	15	144.86
62	RF	RF for clinical assessment and monitoring.	Plasma	45	99.67
63	Anti-CCP	Anti-CCP for clinical assessment and monitoring.	Sputum	45	99.33
64	HIV 1/2 Ag/Ab	HIV 1/2 Ag/Ab for clinical assessment and monitoring.	Stool	30	46.39
65	Hepatitis B Surface Antigen	Hepatitis B Surface Antigen for clinical assessment and monitoring.	Blood	15	99.58
66	Hepatitis C Antibody	Hepatitis C Antibody for clinical assessment and monitoring.	Urine	60	112.11
67	Syphilis RPR	Syphilis RPR for clinical assessment and monitoring.	Blood	20	65.59
68	CRP high sensitivity	CRP high sensitivity for clinical assessment and monitoring.	Plasma	15	149.59
69	Procalcitonin	Procalcitonin for clinical assessment and monitoring.	CSF	45	32.02
70	TSH Receptor Antibodies	TSH Receptor Antibodies for clinical assessment and monitoring.	Stool	15	6.34
71	FSH	FSH for clinical assessment and monitoring.	Pleural Fluid	60	20.56
72	LH	LH for clinical assessment and monitoring.	Saliva	30	70.88
73	Progesterone	Progesterone for clinical assessment and monitoring.	Synovial Fluid	60	76.62
74	Estradiol	Estradiol for clinical assessment and monitoring.	Plasma	60	72.86
75	Testosterone Total	Testosterone Total for clinical assessment and monitoring.	Urine	15	52.95
76	Testosterone Free	Testosterone Free for clinical assessment and monitoring.	Sputum	30	109.20
77	Cortisol AM	Cortisol AM for clinical assessment and monitoring.	Blood	30	119.66
78	Cortisol PM	Cortisol PM for clinical assessment and monitoring.	Pleural Fluid	20	30.45
79	ACTH	ACTH for clinical assessment and monitoring.	CSF	45	79.72
80	Prolactin	Prolactin for clinical assessment and monitoring.	Serum	45	102.04
81	IGF-1	IGF-1 for clinical assessment and monitoring.	Plasma	20	74.23
82	Growth Hormone	Growth Hormone for clinical assessment and monitoring.	Urine	15	42.81
83	Parathyroid Hormone	Parathyroid Hormone for clinical assessment and monitoring.	Urine	45	114.29
84	Ammonia	Ammonia for clinical assessment and monitoring.	Saliva	30	89.46
85	Lactate	Lactate for clinical assessment and monitoring.	Pleural Fluid	15	42.93
86	Blood Culture	Blood Culture for clinical assessment and monitoring.	Saliva	20	14.01
87	Urine Culture	Urine Culture for clinical assessment and monitoring.	Serum	45	49.49
88	Sputum Culture	Sputum Culture for clinical assessment and monitoring.	CSF	60	138.85
89	Stool Culture	Stool Culture for clinical assessment and monitoring.	Stool	15	97.61
90	CSF Analysis	CSF Analysis for clinical assessment and monitoring.	Stool	30	94.12
91	Gram Stain	Gram Stain for clinical assessment and monitoring.	Urine	20	74.34
92	ABG	ABG for clinical assessment and monitoring.	Sputum	60	59.18
93	Venous Blood Gas	Venous Blood Gas for clinical assessment and monitoring.	Synovial Fluid	45	114.82
94	Osmolality Serum	Osmolality Serum for clinical assessment and monitoring.	Urine	20	103.65
95	Osmolality Urine	Osmolality Urine for clinical assessment and monitoring.	Pleural Fluid	15	81.20
96	Special Test 096	Special Test 096 for clinical assessment and monitoring.	Synovial Fluid	30	16.32
97	Special Test 097	Special Test 097 for clinical assessment and monitoring.	Pleural Fluid	15	13.95
98	Special Test 098	Special Test 098 for clinical assessment and monitoring.	Synovial Fluid	60	34.31
99	Special Test 099	Special Test 099 for clinical assessment and monitoring.	Synovial Fluid	20	28.86
100	Special Test 100	Special Test 100 for clinical assessment and monitoring.	Synovial Fluid	45	21.85
\.


--
-- TOC entry 3737 (class 0 OID 0)
-- Dependencies: 238
-- Name: doctors_audit_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctors_audit_audit_id_seq', 4, true);


--
-- TOC entry 3738 (class 0 OID 0)
-- Dependencies: 219
-- Name: doctors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctors_id_seq', 100, true);


--
-- TOC entry 3739 (class 0 OID 0)
-- Dependencies: 217
-- Name: insurers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.insurers_id_seq', 100, true);


--
-- TOC entry 3740 (class 0 OID 0)
-- Dependencies: 242
-- Name: lab_orders_audit_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lab_orders_audit_audit_id_seq', 1, false);


--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 225
-- Name: lab_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lab_orders_id_seq', 100, true);


--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 221
-- Name: panels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.panels_id_seq', 100, true);


--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 227
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parameters_id_seq', 100, true);


--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 240
-- Name: patients_audit_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patients_audit_audit_id_seq', 3, true);


--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 215
-- Name: patients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patients_id_seq', 100, true);


--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 248
-- Name: payments_audit_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_audit_audit_id_seq', 1, true);


--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 231
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_id_seq', 100, true);


--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 246
-- Name: results_audit_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.results_audit_audit_id_seq', 1, false);


--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 236
-- Name: results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.results_id_seq', 100, true);


--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 244
-- Name: samples_audit_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.samples_audit_audit_id_seq', 1, false);


--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 229
-- Name: samples_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.samples_id_seq', 100, true);


--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 223
-- Name: tests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tests_id_seq', 100, true);


--
-- TOC entry 3493 (class 2606 OID 139282)
-- Name: doctors_audit doctors_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors_audit
    ADD CONSTRAINT doctors_audit_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 3471 (class 2606 OID 106582)
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- TOC entry 3485 (class 2606 OID 106665)
-- Name: insurers_patients insurers_patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurers_patients
    ADD CONSTRAINT insurers_patients_pkey PRIMARY KEY (patient_id, insurer_id, policy_number);


--
-- TOC entry 3469 (class 2606 OID 106576)
-- Name: insurers insurers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurers
    ADD CONSTRAINT insurers_pkey PRIMARY KEY (id);


--
-- TOC entry 3497 (class 2606 OID 139342)
-- Name: lab_orders_audit lab_orders_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_orders_audit
    ADD CONSTRAINT lab_orders_audit_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 3477 (class 2606 OID 106609)
-- Name: lab_orders lab_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_orders
    ADD CONSTRAINT lab_orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3489 (class 2606 OID 106695)
-- Name: lab_orders_tests lab_orders_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_orders_tests
    ADD CONSTRAINT lab_orders_tests_pkey PRIMARY KEY (lab_order_id, test_id);


--
-- TOC entry 3473 (class 2606 OID 106590)
-- Name: panels panels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.panels
    ADD CONSTRAINT panels_pkey PRIMARY KEY (id);


--
-- TOC entry 3487 (class 2606 OID 106680)
-- Name: panels_tests panels_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.panels_tests
    ADD CONSTRAINT panels_tests_pkey PRIMARY KEY (panel_id, test_id);


--
-- TOC entry 3479 (class 2606 OID 106626)
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- TOC entry 3495 (class 2606 OID 139312)
-- Name: patients_audit patients_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients_audit
    ADD CONSTRAINT patients_audit_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 3465 (class 2606 OID 106570)
-- Name: patients patients_document_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_document_number_key UNIQUE (document_number);


--
-- TOC entry 3467 (class 2606 OID 106568)
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- TOC entry 3503 (class 2606 OID 139432)
-- Name: payments_audit payments_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments_audit
    ADD CONSTRAINT payments_audit_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 3483 (class 2606 OID 106654)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- TOC entry 3501 (class 2606 OID 139402)
-- Name: results_audit results_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results_audit
    ADD CONSTRAINT results_audit_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 3491 (class 2606 OID 106712)
-- Name: results results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- TOC entry 3499 (class 2606 OID 139372)
-- Name: samples_audit samples_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.samples_audit
    ADD CONSTRAINT samples_audit_pkey PRIMARY KEY (audit_id);


--
-- TOC entry 3481 (class 2606 OID 106641)
-- Name: samples samples_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT samples_pkey PRIMARY KEY (id);


--
-- TOC entry 3475 (class 2606 OID 106598)
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (id);


--
-- TOC entry 3521 (class 2620 OID 155649)
-- Name: doctors ad_doctors_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ad_doctors_audit AFTER DELETE ON public.doctors FOR EACH ROW EXECUTE FUNCTION public.doctors_bd_audit();


--
-- TOC entry 3524 (class 2620 OID 155651)
-- Name: lab_orders ad_lab_orders_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ad_lab_orders_audit AFTER DELETE ON public.lab_orders FOR EACH ROW EXECUTE FUNCTION public.lab_orders_bd_audit();


--
-- TOC entry 3518 (class 2620 OID 155650)
-- Name: patients ad_patients_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ad_patients_audit AFTER DELETE ON public.patients FOR EACH ROW EXECUTE FUNCTION public.patients_bd_audit();


--
-- TOC entry 3530 (class 2620 OID 147458)
-- Name: payments ad_payments_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ad_payments_audit AFTER DELETE ON public.payments FOR EACH ROW EXECUTE FUNCTION public.payments_bd_audit();


--
-- TOC entry 3533 (class 2620 OID 155652)
-- Name: results ad_results_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ad_results_audit AFTER DELETE ON public.results FOR EACH ROW EXECUTE FUNCTION public.results_bd_audit();


--
-- TOC entry 3527 (class 2620 OID 155654)
-- Name: samples ad_samples_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ad_samples_audit AFTER DELETE ON public.samples FOR EACH ROW EXECUTE FUNCTION public.samples_bd_audit();


--
-- TOC entry 3522 (class 2620 OID 139286)
-- Name: doctors ai_doctors_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ai_doctors_audit AFTER INSERT ON public.doctors FOR EACH ROW EXECUTE FUNCTION public.doctors_ai_audit();


--
-- TOC entry 3525 (class 2620 OID 139346)
-- Name: lab_orders ai_lab_orders_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ai_lab_orders_audit AFTER INSERT ON public.lab_orders FOR EACH ROW EXECUTE FUNCTION public.lab_orders_ai_audit();


--
-- TOC entry 3519 (class 2620 OID 139316)
-- Name: patients ai_patients_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ai_patients_audit AFTER INSERT ON public.patients FOR EACH ROW EXECUTE FUNCTION public.patients_ai_audit();


--
-- TOC entry 3531 (class 2620 OID 139436)
-- Name: payments ai_payments_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ai_payments_audit AFTER INSERT ON public.payments FOR EACH ROW EXECUTE FUNCTION public.payments_ai_audit();


--
-- TOC entry 3534 (class 2620 OID 139406)
-- Name: results ai_results_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ai_results_audit AFTER INSERT ON public.results FOR EACH ROW EXECUTE FUNCTION public.results_ai_audit();


--
-- TOC entry 3528 (class 2620 OID 139376)
-- Name: samples ai_samples_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ai_samples_audit AFTER INSERT ON public.samples FOR EACH ROW EXECUTE FUNCTION public.samples_ai_audit();


--
-- TOC entry 3523 (class 2620 OID 139287)
-- Name: doctors au_doctors_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER au_doctors_audit AFTER UPDATE ON public.doctors FOR EACH ROW EXECUTE FUNCTION public.doctors_au_audit();


--
-- TOC entry 3526 (class 2620 OID 139347)
-- Name: lab_orders au_lab_orders_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER au_lab_orders_audit AFTER UPDATE ON public.lab_orders FOR EACH ROW EXECUTE FUNCTION public.lab_orders_au_audit();


--
-- TOC entry 3520 (class 2620 OID 139317)
-- Name: patients au_patients_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER au_patients_audit AFTER UPDATE ON public.patients FOR EACH ROW EXECUTE FUNCTION public.patients_au_audit();


--
-- TOC entry 3532 (class 2620 OID 139437)
-- Name: payments au_payments_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER au_payments_audit AFTER UPDATE ON public.payments FOR EACH ROW EXECUTE FUNCTION public.payments_au_audit();


--
-- TOC entry 3535 (class 2620 OID 139407)
-- Name: results au_results_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER au_results_audit AFTER UPDATE ON public.results FOR EACH ROW EXECUTE FUNCTION public.results_au_audit();


--
-- TOC entry 3529 (class 2620 OID 139377)
-- Name: samples au_samples_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER au_samples_audit AFTER UPDATE ON public.samples FOR EACH ROW EXECUTE FUNCTION public.samples_au_audit();


--
-- TOC entry 3536 (class 2620 OID 139294)
-- Name: doctors_audit bd_doctors_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bd_doctors_audit_block BEFORE DELETE ON public.doctors_audit FOR EACH ROW EXECUTE FUNCTION public.doctors_audit_block_bd();


--
-- TOC entry 3542 (class 2620 OID 139354)
-- Name: lab_orders_audit bd_lab_orders_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bd_lab_orders_audit_block BEFORE DELETE ON public.lab_orders_audit FOR EACH ROW EXECUTE FUNCTION public.lab_orders_audit_block_bd();


--
-- TOC entry 3539 (class 2620 OID 139324)
-- Name: patients_audit bd_patients_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bd_patients_audit_block BEFORE DELETE ON public.patients_audit FOR EACH ROW EXECUTE FUNCTION public.patients_audit_block_bd();


--
-- TOC entry 3551 (class 2620 OID 139444)
-- Name: payments_audit bd_payments_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bd_payments_audit_block BEFORE DELETE ON public.payments_audit FOR EACH ROW EXECUTE FUNCTION public.payments_audit_block_bd();


--
-- TOC entry 3548 (class 2620 OID 139414)
-- Name: results_audit bd_results_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bd_results_audit_block BEFORE DELETE ON public.results_audit FOR EACH ROW EXECUTE FUNCTION public.results_audit_block_bd();


--
-- TOC entry 3545 (class 2620 OID 139384)
-- Name: samples_audit bd_samples_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bd_samples_audit_block BEFORE DELETE ON public.samples_audit FOR EACH ROW EXECUTE FUNCTION public.samples_audit_block_bd();


--
-- TOC entry 3537 (class 2620 OID 139292)
-- Name: doctors_audit bi_doctors_audit_guard; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bi_doctors_audit_guard BEFORE INSERT ON public.doctors_audit FOR EACH ROW EXECUTE FUNCTION public.doctors_audit_guard_bi();


--
-- TOC entry 3543 (class 2620 OID 139352)
-- Name: lab_orders_audit bi_lab_orders_audit_guard; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bi_lab_orders_audit_guard BEFORE INSERT ON public.lab_orders_audit FOR EACH ROW EXECUTE FUNCTION public.lab_orders_audit_guard_bi();


--
-- TOC entry 3540 (class 2620 OID 139322)
-- Name: patients_audit bi_patients_audit_guard; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bi_patients_audit_guard BEFORE INSERT ON public.patients_audit FOR EACH ROW EXECUTE FUNCTION public.patients_audit_guard_bi();


--
-- TOC entry 3552 (class 2620 OID 139442)
-- Name: payments_audit bi_payments_audit_guard; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bi_payments_audit_guard BEFORE INSERT ON public.payments_audit FOR EACH ROW EXECUTE FUNCTION public.payments_audit_guard_bi();


--
-- TOC entry 3549 (class 2620 OID 139412)
-- Name: results_audit bi_results_audit_guard; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bi_results_audit_guard BEFORE INSERT ON public.results_audit FOR EACH ROW EXECUTE FUNCTION public.results_audit_guard_bi();


--
-- TOC entry 3546 (class 2620 OID 139382)
-- Name: samples_audit bi_samples_audit_guard; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bi_samples_audit_guard BEFORE INSERT ON public.samples_audit FOR EACH ROW EXECUTE FUNCTION public.samples_audit_guard_bi();


--
-- TOC entry 3538 (class 2620 OID 139293)
-- Name: doctors_audit bu_doctors_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bu_doctors_audit_block BEFORE UPDATE ON public.doctors_audit FOR EACH ROW EXECUTE FUNCTION public.doctors_audit_block_bu();


--
-- TOC entry 3544 (class 2620 OID 139353)
-- Name: lab_orders_audit bu_lab_orders_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bu_lab_orders_audit_block BEFORE UPDATE ON public.lab_orders_audit FOR EACH ROW EXECUTE FUNCTION public.lab_orders_audit_block_bu();


--
-- TOC entry 3541 (class 2620 OID 139323)
-- Name: patients_audit bu_patients_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bu_patients_audit_block BEFORE UPDATE ON public.patients_audit FOR EACH ROW EXECUTE FUNCTION public.patients_audit_block_bu();


--
-- TOC entry 3553 (class 2620 OID 139443)
-- Name: payments_audit bu_payments_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bu_payments_audit_block BEFORE UPDATE ON public.payments_audit FOR EACH ROW EXECUTE FUNCTION public.payments_audit_block_bu();


--
-- TOC entry 3550 (class 2620 OID 139413)
-- Name: results_audit bu_results_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bu_results_audit_block BEFORE UPDATE ON public.results_audit FOR EACH ROW EXECUTE FUNCTION public.results_audit_block_bu();


--
-- TOC entry 3547 (class 2620 OID 139383)
-- Name: samples_audit bu_samples_audit_block; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bu_samples_audit_block BEFORE UPDATE ON public.samples_audit FOR EACH ROW EXECUTE FUNCTION public.samples_audit_block_bu();


--
-- TOC entry 3509 (class 2606 OID 106671)
-- Name: insurers_patients insurers_patients_insurer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurers_patients
    ADD CONSTRAINT insurers_patients_insurer_id_fkey FOREIGN KEY (insurer_id) REFERENCES public.insurers(id);


--
-- TOC entry 3510 (class 2606 OID 106666)
-- Name: insurers_patients insurers_patients_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurers_patients
    ADD CONSTRAINT insurers_patients_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- TOC entry 3504 (class 2606 OID 106615)
-- Name: lab_orders lab_orders_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_orders
    ADD CONSTRAINT lab_orders_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


--
-- TOC entry 3505 (class 2606 OID 106610)
-- Name: lab_orders lab_orders_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_orders
    ADD CONSTRAINT lab_orders_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- TOC entry 3513 (class 2606 OID 106696)
-- Name: lab_orders_tests lab_orders_tests_lab_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_orders_tests
    ADD CONSTRAINT lab_orders_tests_lab_order_id_fkey FOREIGN KEY (lab_order_id) REFERENCES public.lab_orders(id);


--
-- TOC entry 3514 (class 2606 OID 106701)
-- Name: lab_orders_tests lab_orders_tests_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_orders_tests
    ADD CONSTRAINT lab_orders_tests_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.tests(id);


--
-- TOC entry 3511 (class 2606 OID 106681)
-- Name: panels_tests panels_tests_panel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.panels_tests
    ADD CONSTRAINT panels_tests_panel_id_fkey FOREIGN KEY (panel_id) REFERENCES public.panels(id);


--
-- TOC entry 3512 (class 2606 OID 106686)
-- Name: panels_tests panels_tests_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.panels_tests
    ADD CONSTRAINT panels_tests_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.tests(id);


--
-- TOC entry 3506 (class 2606 OID 106627)
-- Name: parameters parameters_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameters
    ADD CONSTRAINT parameters_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.tests(id);


--
-- TOC entry 3508 (class 2606 OID 106655)
-- Name: payments payments_lab_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_lab_order_id_fkey FOREIGN KEY (lab_order_id) REFERENCES public.lab_orders(id);


--
-- TOC entry 3515 (class 2606 OID 106723)
-- Name: results results_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


--
-- TOC entry 3516 (class 2606 OID 106718)
-- Name: results results_parameter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES public.parameters(id);


--
-- TOC entry 3517 (class 2606 OID 106713)
-- Name: results results_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- TOC entry 3507 (class 2606 OID 106642)
-- Name: samples samples_lab_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT samples_lab_order_id_fkey FOREIGN KEY (lab_order_id) REFERENCES public.lab_orders(id);


-- Completed on 2025-10-16 13:37:19 UTC

--
-- PostgreSQL database dump complete
--

\unrestrict zvIgAYAzdvgp2hhjCF6ZZ4I95AUlPTPbFfH4iKQbz4WP2JvXhJIeTrgeT8ecUpO

