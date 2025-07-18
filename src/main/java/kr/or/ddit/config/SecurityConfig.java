package kr.or.ddit.config;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.security.servlet.PathRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import jakarta.servlet.DispatcherType;
import kr.or.ddit.security.CustomLoginFailureHandler;
import kr.or.ddit.security.CustomLoginSuccessHandler;
import kr.or.ddit.security.CustomOAuth2LoginFailureHandler;
import kr.or.ddit.security.CustomOAuth2LoginSuccessHandler;
import kr.or.ddit.security.CustomOAuth2UserService;
import kr.or.ddit.security.CustomUserDetailsService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
@EnableWebSecurity
public class SecurityConfig {
	
	@Autowired
	private CustomUserDetailsService customUserDetailsService;
	
	@Autowired
	private CustomOAuth2UserService oAuth2UserService;
	
	@Autowired
	private DataSource datasource;
	
	@Bean
	public WebSecurityCustomizer configure() {
		return web -> web.ignoring().requestMatchers(new AntPathRequestMatcher("/resources/**"));
	}
	
	@Bean
	protected SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		// 시큐리티 csrf 토큰 키는 '${_csrf.headerName}', 토큰 값은 '${_csrf.token}'으로 설정
		
		http.httpBasic((basic)-> basic.disable());
		
		http.authorizeHttpRequests((authorize)->
			authorize.dispatcherTypeMatchers(DispatcherType.FORWARD,DispatcherType.ASYNC).permitAll()
			.requestMatchers(PathRequest.toStaticResources().atCommonLocations()).permitAll()
			.requestMatchers("/resources/**").permitAll()
			.requestMatchers("/error").permitAll()
			.requestMatchers("/favicon.ico").permitAll()
			.requestMatchers("/.well-known/**").permitAll()
			.requestMatchers("/").permitAll()
			.requestMatchers("/login").permitAll()
			.requestMatchers("/signup/**").permitAll()
			.anyRequest().authenticated()
		);
		
		
		http.formLogin((login)->login.loginPage("/login")
				.successHandler(new CustomLoginSuccessHandler())
				.failureHandler(new CustomLoginFailureHandler())
		);
		
		http.oauth2Login((oauth2) -> oauth2
							.userInfoEndpoint((endPoint) -> endPoint.userService(oAuth2UserService))
							.loginPage("/login")
							.successHandler(new CustomOAuth2LoginSuccessHandler())
							.failureHandler(new CustomOAuth2LoginFailureHandler())		
		);
		
		
		http.logout(logout -> logout.logoutUrl("/logout")
									.invalidateHttpSession(true)
									.logoutSuccessUrl("/")
		);
		
		return http.build();
	}

	@Bean
	protected BCryptPasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	@Bean
	protected AuthenticationManager authenticationManger(HttpSecurity http, BCryptPasswordEncoder bCryptPasswordEncoder,
			UserDetailsService userDetailsService ) {
		DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
		authProvider.setUserDetailsService(customUserDetailsService);
		authProvider.setPasswordEncoder(bCryptPasswordEncoder);
		return new ProviderManager(authProvider);
	}
	
}
