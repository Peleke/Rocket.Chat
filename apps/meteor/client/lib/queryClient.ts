import { QueryClient } from '@tanstack/react-query';
import { Logger } from '@rocket.chat/logger';

const logger = new Logger('QueryClient');

export const queryClient = new QueryClient({
	defaultOptions: {
		queries: {
			refetchOnWindowFocus: false,
			retry: process.env.TEST_MODE === 'true',
		},
		mutations: {
			onError: (error) => logger.warn(error),
		},
	},
});
